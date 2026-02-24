//
//  CrossGameRewards.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/23/26.
//

import Foundation
public class AeonicRewardTable : ScriptableObject
{
    [Header("Taimanin Rewards")]
    public TaimaninWeapon[] taimaninWeapons;
    public TaimaninCostume[] exclusiveCostumes;
    public TaimaninSkill[] awakenedSkills;
    
    [Header("Final Chronicle Rewards")]
    public ChronicleWeapon[] cosmicWeapons;
    public StarshipUpgrade[] shipUpgrades;
    public PlanetUnlock[] hiddenPlanets;
    
    [Header("Universal Rewards")]
    public CurrencyBonus aeonicCrystals;
    public CrossDimensionFusion[] fusionItems;
}
