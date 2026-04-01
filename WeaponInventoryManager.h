//
//  WeaponInventoryManager.h
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/22/26.
//

#import <Foundation/Foundation.h>
public class WeaponInventory : MonoBehaviour
{
    public static WeaponInventory Instance;
    
    private Dictionary<string, WeaponData> ownedWeapons = new Dictionary<string, WeaponData>();
    private Dictionary<string, WeaponData> equippedWeapons = new Dictionary<string, WeaponData>(); // CharacterID -> Weapon
    
    public event System.Action<string> OnWeaponAdded; // WeaponName
    public event System.Action<string, string> OnWeaponEquipped; // CharacterName, WeaponName
    
    public void AddWeapon(WeaponData weapon)
    {
        if (!ownedWeapons.ContainsKey(weapon.weaponName))
        {
            ownedWeapons.Add(weapon.weaponName, weapon);
            OnWeaponAdded?.Invoke(weapon.weaponName);
            Debug.Log($"Added {weapon.weaponName} to inventory!");
        }
    }
    
    public void EquipWeapon(CharacterData character, WeaponData weapon)
    {
        if (ownedWeapons.ContainsKey(weapon.weaponName))
        {
            equippedWeapons[character.characterName] = weapon;
            OnWeaponEquipped?.Invoke(character.characterName, weapon.weaponName);
        }
    }
    
    public List<WeaponData> GetWeaponsForCharacter(CharacterData character)
    {
        return ownedWeapons.Values.Where(w =>
            w.preferredWielder == null || w.preferredWielder == character
        ).ToList();
    }
}
