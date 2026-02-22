//
//  Jen_And_Altima_Voicelines.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import UIKit

class Jen_And_Altima_Voicelines: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
# jen_altima_voice_lines.py

from enum import Enum
from typing import Dict, List
import random

class CharacterVoice(Enum):
    JEN = "Jen"
    ALTIMA = "Altima"

class EmotionalState(Enum):
    ANGRY = "Angry"
    HAPPY = "Happy"
    SAD = "Sad"
    FEARFUL = "Fearful"
    DETERMINED = "Determined"
    CONFUSED = "Confused"
    SARCASTIC = "Sarcastic"

class JenAltimaVoiceLines:
    def __init__(self):
        self.voice_databases = self._initialize_voice_databases()
        self.current_emotional_states = {
            CharacterVoice.JEN: EmotionalState.DETERMINED,
            CharacterVoice.ALTIMA: EmotionalState.NEUTRAL
        }
    
    def _initialize_voice_databases(self) -> Dict:
        """Voice lines categorized by character and emotion"""
        return {
            CharacterVoice.JEN: {
                EmotionalState.DETERMINED: [
                    "I'm not stopping until I find the truth.",
                    "The lattice won't stabilize itself.",
                    "I've come too far to turn back now.",
                    "Let's finish this."
                ],
                EmotionalState.CONFUSED: [
                    "None of this makes sense...",
                    "I feel like I'm missing something important.",
                    "Why would they hide this from me?",
                    "There are too many unanswered questions."
                ],
                EmotionalState.VULNERABLE: [
                    "Sometimes I wonder if I'm doing the right thing.",
                    "I never asked for this responsibility.",
                    "It gets lonely, traveling between dimensions.",
                    "I miss having someone to trust."
                ],
                EmotionalState.SARCASTIC: [
                    "Oh great, more mysterious ruins. My favorite.",
                    "Because what this situation needed was more existential dread.",
                    "Another day, another reality-threatening crisis.",
                    "I'm starting to think the universe has it out for me."
                ]
            },
            CharacterVoice.ALTIMA: {
                EmotionalState.NEUTRAL: [
                    "The data suggests we proceed with caution.",
                    "My calculations indicate a 67% chance of success.",
                    "The dimensional readings are... anomalous.",
                    "I've seen this pattern before."
                ],
                EmotionalState.ANGRY: [
                    "Your recklessness will get us both killed!",
                    "I warned you this would happen.",
                    "Sometimes I wonder why I bother helping you.",
                    "The fate of realities rests on this, and you're joking?"
                ],
                EmotionalState.HAPPY: [
                    "The lattice stabilization is proceeding optimally.",
                    "We make an effective team, it seems.",
                    "Finally, a breakthrough in the research.",
                    "Your progress is... impressive."
                ],
                EmotionalState.FEARFUL: [
                    "The anomalies are growing stronger.",
                    "I've never seen the lattice this unstable.",
                    "We may be in over our heads.",
                    "The consequences of failure are... unimaginable."
                ]
            }
        }
    
    def get_voice_line(self, character: CharacterVoice, emotion: EmotionalState = None) -> str:
        """Get a voice line for a character with optional emotion override"""
        if emotion is None:
            emotion = self.current_emotional_states[character]
        
        voice_db = self.voice_databases.get(character, {})
        emotion_lines = voice_db.get(emotion, [])
        
        if emotion_lines:
            return random.choice(emotion_lines)
        else:
            # Fallback to neutral if specific emotion not found
            neutral_lines = voice_db.get(EmotionalState.NEUTRAL, ["..."])
            return random.choice(neutral_lines)
    
    def set_emotional_state(self, character: CharacterVoice, emotion: EmotionalState):
        """Set a character's current emotional state"""
        self.current_emotional_states[character] = emotion
    
    def get_emotional_reaction(self, event_type: str, severity: int) -> Dict:
        """Get emotional reactions to game events"""
        reactions = {
            "battle_victory": {
                CharacterVoice.JEN: EmotionalState.DETERMINED,
                CharacterVoice.ALTIMA: EmotionalState.HAPPY if severity > 5 else EmotionalState.NEUTRAL
            },
            "battle_loss": {
                CharacterVoice.JEN: EmotionalState.CONFUSED,
                CharacterVoice.ALTIMA: EmotionalState.ANGRY if severity > 3 else EmotionalState.FEARFUL
            },
            "story_revelation": {
                CharacterVoice.JEN: EmotionalState.CONFUSED,
                CharacterVoice.ALTIMA: EmotionalState.NEUTRAL
            },
            "near_death": {
                CharacterVoice.JEN: EmotionalState.FEARFUL,
                CharacterVoice.ALTIMA: EmotionalState.FEARFUL
            }
        }
        
        return reactions.get(event_type, {
            CharacterVoice.JEN: EmotionalState.NEUTRAL,
            CharacterVoice.ALTIMA: EmotionalState.NEUTRAL
        })
    
    def generate_conversation_exchange(self, context: str) -> List[Dict]:
        """Generate a natural conversation exchange"""
        exchanges = []
        
        # Determine emotional states based on context
        if context == "planning":
            self.set_emotional_state(CharacterVoice.JEN, EmotionalState.DETERMINED)
            self.set_emotional_state(CharacterVoice.ALTIMA, EmotionalState.NEUTRAL)
        elif context == "crisis":
            self.set_emotional_state(CharacterVoice.JEN, EmotionalState.FEARFUL)
            self.set_emotional_state(CharacterVoice.ALTIMA, EmotionalState.ANGRY)
        elif context == "reflection":
            self.set_emotional_state(CharacterVoice.JEN, EmotionalState.VULNERABLE)
            self.set_emotional_state(CharacterVoice.ALTIMA, EmotionalState.HAPPY)
        
        # Generate 2-4 exchange conversation
        num_exchanges = random.randint(2, 4)
        
        for i in range(num_exchanges):
            # Alternate speakers
            speaker = CharacterVoice.JEN if i % 2 == 0 else CharacterVoice.ALTIMA
            line = self.get_voice_line(speaker)
            
            exchanges.append({
                "speaker": speaker.value,
                "line": line,
                "emotion": self.current_emotional_states[speaker].value
            })
            
            # Slight emotion shift through conversation
            if i < num_exchanges - 1:
                self._progress_emotion(speaker, context)
        
        return exchanges
    
    def _progress_emotion(self, character: CharacterVoice, context: str):
        """Progress emotional state through a conversation"""
        emotion_progression = {
            "planning": {
                EmotionalState.DETERMINED: EmotionalState.CONFUSED,
                EmotionalState.CONFUSED: EmotionalState.DETERMINED
            },
            "crisis": {
                EmotionalState.FEARFUL: EmotionalState.DETERMINED,
                EmotionalState.ANGRY: EmotionalState.FEARFUL
            },
            "reflection": {
                EmotionalState.VULNERABLE: EmotionalState.HAPPY,
                EmotionalState.HAPPY: EmotionalState.VULNERABLE
            }
        }
        
        current_emotion = self.current_emotional_states[character]
        progression = emotion_progression.get(context, {}).get(current_emotion)
        
        if progression:
            self.set_emotional_state(character, progression)
