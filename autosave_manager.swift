//
//  autosave_manager.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# autosave_manager.py

import json
import threading
import time
from typing import Dict, Any, Callable
from datetime import datetime, timedelta
from game_economy import GameEconomy

class AutosaveManager:
    def __init__(self, economy: GameEconomy, save_callback: Callable, load_callback: Callable):
        self.economy = economy
        self.save_callback = save_callback
        self.load_callback = load_callback
        
        # Autosave configuration
        self.config = {
            'autosave_interval': 300,  # 5 minutes in seconds
            'max_autosave_slots': 5,
            'backup_interval': 3600,  # 1 hour
            'enable_cloud_backup': False
        }
        
        # Autosave state
        self.autosave_slots = {}
        self.last_autosave_time = datetime.now()
        self.last_backup_time = datetime.now()
        self.is_autosave_enabled = True
        self.autosave_thread = None
        self.shutdown_flag = False
        
        # Critical event triggers for immediate autosave
        self.critical_events = [
            'major_purchase',  # Purchases over 10,000 credits
            'level_up',        # Character level up
            'quest_complete',  # Quest completion
            'region_change',   # Changing game regions
            'combat_end'       # After significant combat
        ]
    
    def start_autosave_service(self):
        """Start the autosave service in a background thread"""
        if self.autosave_thread and self.autosave_thread.is_alive():
            return  # Already running
        
        self.shutdown_flag = False
        self.autosave_thread = threading.Thread(target=self._autosave_loop, daemon=True)
        self.autosave_thread.start()
        
        return "Autosave service started"
    
    def stop_autosave_service(self):
        """Stop the autosave service"""
        self.shutdown_flag = True
        if self.autosave_thread:
            self.autosave_thread.join(timeout=5)
        
        return "Autosave service stopped"
    
    def _autosave_loop(self):
        """Main autosave loop running in background thread"""
        while not self.shutdown_flag:
            try:
                current_time = datetime.now()
                
                # Check for regular autosave
                time_since_autosave = (current_time - self.last_autosave_time).total_seconds()
                if time_since_autosave >= self.config['autosave_interval']:
                    self._perform_autosave("scheduled")
                
                # Check for backup
                time_since_backup = (current_time - self.last_backup_time).total_seconds()
                if time_since_backup >= self.config['backup_interval']:
                    self._perform_backup()
                
                # Sleep for a bit to avoid busy waiting
                time.sleep(30)  # Check every 30 seconds
                
            except Exception as e:
                print(f"Autosave error: {e}")
                time.sleep(60)  # Wait longer on error
    
    def trigger_critical_autosave(self, event_type: str, event_data: Dict = None):
        """Trigger an immediate autosave for critical events"""
        if not self.is_autosave_enabled:
            return
        
        if event_type in self.critical_events:
            slot_name = f"critical_{event_type}_{datetime.now().strftime('%H%M%S')}"
            self._perform_autosave(slot_name, event_data)
            
            return f"Critical autosave triggered for {event_type}"
    
    def _perform_autosave(self, reason: str, event_data: Dict = None):
        """Perform an autosave operation"""
        try:
            timestamp = datetime.now()
            slot_name = f"autosave_{timestamp.strftime('%Y%m%d_%H%M%S')}"
            
            # Prepare save metadata
            metadata = {
                'timestamp': timestamp.isoformat(),
                'reason': reason,
                'event_data': event_data or {},
                'wallet_state': dict(self.economy.wallet),
                'game_time': timestamp.strftime('%Y-%m-%d %H:%M:%S')
            }
            
            # Perform the save using the callback
            success = self.save_callback(slot_name, metadata)
            
            if success:
                self.last_autosave_time = timestamp
                
                # Manage autosave slots (keep only most recent N)
                self._manage_autosave_slots(slot_name, metadata)
                
                print(f"✅ Autosave completed: {slot_name} ({reason})")
            else:
                print(f"❌ Autosave failed: {slot_name}")
                
        except Exception as e:
            print(f"❌ Autosave error: {e}")
    
    def _perform_backup(self):
        """Perform a backup operation"""
        try:
            timestamp = datetime.now()
            backup_name = f"backup_{timestamp.strftime('%Y%m%d_%H%M')}"
            
            # Create comprehensive backup
            backup_data = {
                'timestamp': timestamp.isoformat(),
                'economy_state': self._get_economy_state(),
                'autosave_slots': self.autosave_slots,
                'config': self.config
            }
            
            # Save backup to file
            filename = f"{backup_name}.json"
            with open(filename, 'w') as f:
                json.dump(backup_data, f, indent=2, default=str)
            
            self.last_backup_time = timestamp
            print(f"💾 Backup completed: {filename}")
            
            # Optional: Cloud backup
            if self.config['enable_cloud_backup']:
                self._cloud_backup(backup_data, filename)
                
        except Exception as e:
            print(f"❌ Backup error: {e}")
    
    def _manage_autosave_slots(self, new_slot: str, metadata: Dict):
        """Manage autosave slots to prevent unlimited growth"""
        self.autosave_slots[new_slot] = metadata
        
        # Remove oldest slots if we exceed the limit
        if len(self.autosave_slots) > self.config['max_autosave_slots']:
            # Get sorted slots by timestamp
            sorted_slots = sorted(
                self.autosave_slots.items(),
                key=lambda x: x[1]['timestamp']
            )
            
            # Remove oldest ones beyond limit
            for slot_to_remove, _ in sorted_slots[:len(sorted_slots) - self.config['max_autosave_slots']]:
                del self.autosave_slots[slot_to_remove]
                
                # Also remove the physical file
                import os
                filename = f"economy_save_{slot_to_remove}.json"
                if os.path.exists(filename):
                    os.remove(filename)
    
    def _get_economy_state(self) -> Dict[str, Any]:
        """Extract economy state for backup"""
        return {
            'wallet': dict(self.economy.wallet),
            'market_trends': {
                region.value: trend for region, trend in self.economy.market_trends.items()
            },
            'trade_history_count': len(self.economy.trade_history),
            'active_events_count': len(self.economy.active_events)
        }
    
    def _cloud_backup(self, backup_data: Dict, filename: str):
        """Optional cloud backup implementation"""
        # This would integrate with cloud storage services
        # For now, just simulate the concept
        print(f"☁️  Cloud backup simulated for {filename}")
    
    def get_autosave_status(self) -> Dict:
        """Get current autosave system status"""
        return {
            'autosave_enabled': self.is_autosave_enabled,
            'last_autosave': self.last_autosave_time.isoformat(),
            'last_backup': self.last_backup_time.isoformat(),
            'autosave_slots_count': len(self.autosave_slots),
            'next_autosave_in': self._time_until_next_autosave(),
            'critical_events_monitored': self.critical_events,
            'config': self.config
        }
    
    def _time_until_next_autosave(self) -> str:
        """Calculate time until next autosave"""
        next_autosave = self.last_autosave_time + timedelta(seconds=self.config['autosave_interval'])
        time_remaining = next_autosave - datetime.now()
        
        if time_remaining.total_seconds() <= 0:
            return "Due now"
        else:
            minutes = int(time_remaining.total_seconds() // 60)
            seconds = int(time_remaining.total_seconds() % 60)
            return f"{minutes}m {seconds}s"
    
    def restore_from_autosave(self, slot_name: str) -> bool:
        """Restore game state from an autosave slot"""
        if slot_name not in self.autosave_slots:
            return False
        
        try:
            # Load the save data
            filename = f"economy_save_{slot_name}.json"
            with open(filename, 'r') as f:
                save_data = json.load(f)
            
            # Use the load callback to restore state
            success = self.load_callback(slot_name)
            
            if success:
                print(f"✅ Restored from autosave: {slot_name}")
                return True
            else:
                print(f"❌ Restore failed: {slot_name}")
                return False
                
        except Exception as e:
            print(f"❌ Restore error: {e}")
            return False
    
    def list_autosave_slots(self) -> Dict[str, Dict]:
        """List all available autosave slots with details"""
        slot_details = {}
        
        for slot_name, metadata in self.autosave_slots.items():
            slot_details[slot_name] = {
                'timestamp': metadata.get('timestamp', 'Unknown'),
                'reason': metadata.get('reason', 'Unknown'),
                'wallet_total': sum(metadata.get('wallet_state', {}).values()),
                'game_time': metadata.get('game_time', 'Unknown')
            }
        
        return slot_details

# Example usage with the save system
class EnhancedEconomySaveSystem:
    def __init__(self, economy: GameEconomy):
        self.economy = economy
        self.autosave_manager = AutosaveManager(
            economy,
            self.save_game,
            self.load_game
        )
    
    def save_game(self, slot_name: str, metadata: Dict = None) -> bool:
        """Enhanced save method integrated with autosave"""
        try:
            save_data = {
                "timestamp": datetime.now().isoformat(),
                "economy_state": self._get_comprehensive_economy_state(),
                "metadata": metadata or {},
                "version": "2.0",
                "checksum": self._generate_checksum()
            }
            
            filename = f"economy_save_{slot_name}.json"
            with open(filename, 'w') as f:
                json.dump(save_data, f, indent=2, default=str)
            
            return True
            
        except Exception as e:
            print(f"Save failed: {e}")
            return False
    
    def load_game(self, slot_name: str) -> bool:
        """Enhanced load method"""
        try:
            filename = f"economy_save_{slot_name}.json"
            with open(filename, 'r') as f:
                save_data = json.load(f)
            
            self._restore_economy_state(save_data["economy_state"])
            return True
            
        except Exception as e:
            print(f"Load failed: {e}")
            return False
    
    def _get_comprehensive_economy_state(self) -> Dict[str, Any]:
        """Get comprehensive economy state including recent activity"""
        return {
            "wallet": dict(self.economy.wallet),
            "market_trends": {
                region.value: trend for region, trend in self.economy.market_trends.items()
            },
            "active_events": [
                {
                    "name": event["name"],
                    "start_time": event["start_time"].isoformat(),
                    "end_time": event["end_time"].isoformat(),
                    "effects": event["effects"]
                }
                for event in self.economy.active_events
            ],
            "recent_transactions": self.economy.trade_history[-50:],  # Last 50 transactions
            "price_modifiers": self.economy.price_modifiers,
            "regional_markets": {
                region.value: market for region, market in self.economy.regional_markets.items()
            },
            "economic_health": self._calculate_economic_health()
        }
    
    def _generate_checksum(self) -> str:
        """Generate a simple checksum for data integrity"""
        import hashlib
        data_str = str(self._get_comprehensive_economy_state())
        return hashlib.md5(data_str.encode()).hexdigest()
    
    def _calculate_economic_health(self) -> float:
        """Calculate overall economic health score"""
        # Simplified health calculation
        wallet_health = min(100, sum(self.economy.wallet.values()) / 1000)
        market_health = sum(
            trend.get('momentum', 0) + 50 for trend in self.economy.market_trends.values()
        ) / len(self.economy.market_trends.values()) if self.economy.market_trends else 50
        
        return (wallet_health + market_health) / 2

# Example usage
if __name__ == "__main__":
    economy = GameEconomy()
    reports = EconomicReports(economy)
    save_system = EnhancedEconomySaveSystem(economy)
    
    # Generate a beautiful report
    print("=== ECONOMIC REPORT ===")
    print(reports.generate_comprehensive_report())
    
    # Test autosave system
    save_system.autosave_manager.start_autosave_service()
    print("Autosave status:", save_system.autosave_manager.get_autosave_status())
    
    # Simulate a critical event
    save_system.autosave_manager.trigger_critical_autosave("major_purchase", {"amount": 15000})
    
    # Generate profitability report
    print("\n=== PROFITABILITY REPORT ===")
    print(reports.generate_profitability_report(7))
