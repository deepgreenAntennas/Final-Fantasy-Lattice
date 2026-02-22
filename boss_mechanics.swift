//
//  boss_mechanics.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# boss_mechanics.py

from enum import Enum
from typing import Dict, List, Any, Callable
import random

class BossPhase(Enum):
    PHASE_1 = "Phase 1: Introduction"
    PHASE_2 = "Phase 2: Aggressive"
    PHASE_3 = "Phase 3: Desperation"
    PHASE_4 = "Phase 4: Final Stand"
    PHASE_5 = "Phase 5: Ultimate"

class BossMechanic(Enum):
    ADD_SPAWNING = "Add Spawning"
    ENRAGE_TIMER = "Enrage Timer"
    ENVIRONMENT_CHANGES = "Environment Changes"
    PHASE_TRANSITIONS = "Phase Transitions"
    WEAKNESS_EXPOSURE = "Weakness Exposure"
    CASCADE_FAILURE = "Cascade Failure"

class BossEncounter:
    def __init__(self, boss_enemy, mechanics: List[BossMechanic]):
        self.boss = boss_enemy
        self.mechanics = mechanics
        self.current_phase = BossPhase.PHASE_1
        self.phase_hp_thresholds = self._calculate_phase_thresholds()
        self.active_mechanics = []
        self.mechanic_cooldowns = {}
        self.special_actions_taken = 0
        
    def _calculate_phase_thresholds(self) -> Dict[BossPhase, float]:
        """Calculate HP percentages for phase transitions"""
        return {
            BossPhase.PHASE_1: 1.0,    # 100-76%
            BossPhase.PHASE_2: 0.75,   # 75-51%
            BossPhase.PHASE_3: 0.5,    # 50-26%
            BossPhase.PHASE_4: 0.25,   # 25-1%
            BossPhase.PHASE_5: 0.0     # 0% (enrage)
        }
    
    def update_phase(self, current_hp_percent: float):
        """Update boss phase based on HP"""
        new_phase = self.current_phase
        
        for phase, threshold in self.phase_hp_thresholds.items():
            if current_hp_percent > threshold:
                new_phase = phase
                break
        
        if new_phase != self.current_phase:
            old_phase = self.current_phase
            self.current_phase = new_phase
            self._trigger_phase_transition(old_phase, new_phase)
    
    def _trigger_phase_transition(self, old_phase: BossPhase, new_phase: BossPhase):
        """Handle phase transition effects"""
        transition_effects = {
            (BossPhase.PHASE_1, BossPhase.PHASE_2): self._phase_1_to_2,
            (BossPhase.PHASE_2, BossPhase.PHASE_3): self._phase_2_to_3,
            (BossPhase.PHASE_3, BossPhase.PHASE_4): self._phase_3_to_4,
            (BossPhase.PHASE_4, BossPhase.PHASE_5): self._phase_4_to_5
        }
        
        transition_func = transition_effects.get((old_phase, new_phase))
        if transition_func:
            transition_func()
    
    def _phase_1_to_2(self):
        """Phase 1 to 2 transition"""
        self.boss.stats["attack"] = int(self.boss.stats["attack"] * 1.3)
        self.active_mechanics.append(BossMechanic.ADD_SPAWNING)
        print("🔸 Boss enters Phase 2: Becoming more aggressive!")
    
    def _phase_2_to_3(self):
        """Phase 2 to 3 transition"""
        self.boss.stats["defense"] = int(self.boss.stats["defense"] * 0.8)  # More vulnerable
        self.boss.stats["attack"] = int(self.boss.stats["attack"] * 1.2)
        self.active_mechanics.append(BossMechanic.ENRAGE_TIMER)
        print("🔸 Boss enters Phase 3: Getting desperate!")
    
    def _phase_3_to_4(self):
        """Phase 3 to 4 transition"""
        self.boss.stats["hp"] = int(self.boss.stats["hp"] * 1.2)  # Final stand HP boost
        self.active_mechanics.append(BossMechanic.WEAKNESS_EXPOSURE)
        print("🔸 Boss enters Phase 4: Final stand!")
    
    def _phase_4_to_5(self):
        """Phase 4 to 5 transition (Enrage)"""
        self.boss.stats["attack"] = int(self.boss.stats["attack"] * 2.0)
        self.boss.stats["speed"] = int(self.boss.stats["speed"] * 1.5)
        self.active_mechanics.append(BossMechanic.CASCADE_FAILURE)
        print("💀 BOSS ENRAGE: Ultimate phase activated!")
    
    def execute_boss_turn(self, combat_state: Dict) -> List[Dict]:
        """Execute boss's turn with phase-appropriate actions"""
        actions = []
        
        # Phase-specific actions
        phase_actions = self._get_phase_actions()
        chosen_action = random.choice(phase_actions)
        actions.append(self._execute_boss_action(chosen_action, combat_state))
        
        # Mechanic actions
        for mechanic in self.active_mechanics:
            if self._can_use_mechanic(mechanic):
                mechanic_action = self._execute_mechanic(mechanic, combat_state)
                if mechanic_action:
                    actions.append(mechanic_action)
        
        self.special_actions_taken += len(actions)
        return actions
    
    def _get_phase_actions(self) -> List[Dict]:
        """Get actions available in current phase"""
        phase_actions = {
            BossPhase.PHASE_1: [
                {"name": "Basic Attack", "power": 15, "type": "physical"},
                {"name": "Taunt", "power": 0, "type": "support", "effect": "draw_aggro"}
            ],
            BossPhase.PHASE_2: [
                {"name": "Enhanced Strike", "power": 25, "type": "physical"},
                {"name": "Area Denial", "power": 20, "type": "aoe", "effect": "create_hazard"}
            ],
            BossPhase.PHASE_3: [
                {"name": "Desperation Attack", "power": 35, "type": "magic"},
                {"name": "Healing Factor", "power": 0, "type": "support", "effect": "self_heal"}
            ],
            BossPhase.PHASE_4: [
                {"name": "Final Gambit", "power": 45, "type": "ultimate"},
                {"name": "Last Resort", "power": 40, "type": "aoe", "effect": "high_damage"}
            ],
            BossPhase.PHASE_5: [
                {"name": "Obliteration", "power": 60, "type": "ultimate"},
                {"name": "Reality Collapse", "power": 50, "type": "aoe", "effect": "wipe"}
            ]
        }
        
        return phase_actions.get(self.current_phase, phase_actions[BossPhase.PHASE_1])
    
    def _execute_boss_action(self, action: Dict, combat_state: Dict) -> Dict:
        """Execute a boss action"""
        return {
            "boss": self.boss.name,
            "action": action["name"],
            "phase": self.current_phase.value,
            "targets": combat_state.get("player_party", []),
            "damage": action.get("power", 0),
            "effect": action.get("effect", "none")
        }
    
    def _can_use_mechanic(self, mechanic: BossMechanic) -> bool:
        """Check if a mechanic can be used"""
        cooldown = self.mechanic_cooldowns.get(mechanic, 0)
        return cooldown <= 0
    
    def _execute_mechanic(self, mechanic: BossMechanic, combat_state: Dict) -> Dict:
        """Execute a boss mechanic"""
        mechanic_effects = {
            BossMechanic.ADD_SPAWNING: self._spawn_adds,
            BossMechanic.ENRAGE_TIMER: self._enrage_timer,
            BossMechanic.ENVIRONMENT_CHANGES: self._change_environment,
            BossMechanic.WEAKNESS_EXPOSURE: self._expose_weakness,
            BossMechanic.CASCADE_FAILURE: self._cascade_failure
        }
        
        effect_func = mechanic_effects.get(mechanic)
        if effect_func:
            result = effect_func(combat_state)
            self.mechanic_cooldowns[mechanic] = result.get("cooldown", 3)
            return result
        return {}
    
    def _spawn_adds(self, combat_state: Dict) -> Dict:
        """Spawn additional enemies"""
        add_count = min(3, self.special_actions_taken // 2 + 1)
        return {
            "mechanic": "Add Spawning",
            "effect": f"Spawn {add_count} additional enemies",
            "cooldown": 4,
            "severity": "moderate"
        }
    
    def _enrage_timer(self, combat_state: Dict) -> Dict:
        """Enrage timer mechanic"""
        turns_remaining = 10 - (self.special_actions_taken // 2)
        return {
            "mechanic": "Enrage Timer",
            "effect": f"Enraging in {turns_remaining} turns!",
            "cooldown": 2,
            "warning_level": "high" if turns_remaining <= 3 else "medium"
        }
    
    def _change_environment(self, combat_state: Dict) -> Dict:
        """Change battlefield environment"""
        environments = ["Lattice Storm", "Temporal Flux", "Reality Tear", "Dimensional Void"]
        new_environment = random.choice(environments)
        return {
            "mechanic": "Environment Change",
            "effect": f"Battlefield becomes {new_environment}",
            "cooldown": 5,
            "environment": new_environment
        }
    
    def _expose_weakness(self, combat_state: Dict) -> Dict:
        """Expose boss weakness temporarily"""
        return {
            "mechanic": "Weakness Exposure",
            "effect": "Boss becomes vulnerable to specific damage types",
            "cooldown": 3,
            "vulnerability": "increased_damage"
        }
    
    def _cascade_failure(self, combat_state: Dict) -> Dict:
        """Cascade failure mechanic"""
        return {
            "mechanic": "Cascade Failure",
            "effect": "Multiple mechanics trigger simultaneously",
            "cooldown": 6,
            "severity": "extreme"
        }
