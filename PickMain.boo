namespace PickBlock

import System
import TShockAPI
import Terraria

public struct PickPlayer:
	x as int
	y as int
	pick as bool
	
	def ToString():
		return "X: " + x + " Y: " + y + " Pick: " + pick
						
[APIVersion(1,12)]
public class PickBlock(TerrariaPlugin):
	Players as Array = array(PickPlayer, 255)
	TileIDMapping = {0: 'Dirt Block',
					1: 'Stone Block',
					3: 'Mushroom',
					4: 'Torch',
					6: 'Iron Ore',
					7: 'Copper Ore',
					8: 'Gold Ore',
					9: 'Silver Ore',
					10: 'Wooden Door',
					12: 'Life Crystal',
					13: 'Bottle',
					14: 'Wooden Table',
					15: 'Wooden Chair',
					16: 'Iron Anvil',
					17: 'Furnace',
					18: 'Workbench',
					19: 'Wood Platform',
					21: 'Chest',
					22: 'Demonite Ore',
					24: 'Vile Mushroom',
					25: 'Ebonstone Block',
					27: 'Sunflower',
					29: 'Piggy Bank',
					30: 'Wood',
					33: 'Candle',
					34: 'Copper Chandelier',
					35: 'Silver Chandelier',
					36: 'Gold Chandelier',
					37: 'Meteorite',
					38: 'Gray Brick',
					39: 'Red Brick',
					40: 'Clay Block',
					41: 'Blue Brick',
					42: 'Chain Lantern',
					43: 'Green Brick',
					44: 'Pink Brick',
					45: 'Gold Brick',
					46: 'Silver Brick',
					47: 'Copper Brick',
					48: 'Spike',
					49: 'Water Candle',
					50: 'Book',
					51: 'Cobweb',
					53: 'Sand Block',
					54: 'Glass',
					55: 'Sign',
					56: 'Obsidian',
					57: 'Ash',
					58: 'Hellstone',
					59: 'Mud Block',
					63: 'Sapphire',
					64: 'Ruby',
					65: 'Emerald',
					66: 'Topaz',
					67: 'Amethyst',
					68: 'Diamond',
					71: 'Glowing Mushroom',
					75: 'Obsidian Brick',
					76: 'Hellstone Brick',
					77: 'Hellforge',
					78: 'Clay Pot',
					79: 'Bed',
					80: 'Cactus',
					81: 'Coral',
					85: 'Tombstone',
					86: 'Loom',
					87: 'Piano',
					88: 'Dresser',
					89: 'Bench',
					90: 'Bathtub',
					92: 'Lamp Post',
					93: 'Tiki Torch',
					94: 'Keg',
					95: 'Chinese Lantern',
					96: 'Cooking Pot',
					97: 'Safe',
					98: 'Skull Lantern',
					100: 'Candelabra',
					101: 'Bookcase',
					102: 'Throne',
					103: 'Bowl',
					104: 'Grandfather Clock',
					106: 'Sawmill',
					107: 'Cobalt Ore',
					108: 'Mythril Ore',
					111: 'Adamantite Ore',
					112: 'Ebonsand Block',
					114: "Tinkerer's Workshop",
					116: 'Pearlsand Block',
					117: 'Pearlstone Block',
					118: 'Pearlstone Brick',
					119: 'Iridescent Brick',
					120: 'Mudstone Brick',
					121: 'Cobalt Brick',
					122: 'Mythril Brick',
					123: 'Silt Block',
					124: 'Wooden Beam',
					125: 'Crystal Ball',
					126: 'Disco Ball',
					128: 'Mannequin',
					129: 'Crystal Shard',
					130: 'Active Stone Block',
					131: 'Inactive Stone Block',
					132: 'Lever',
					133: 'Adamantite Forge',
					134: 'Mythril Anvil',
					136: 'Switch',
					137: 'Dart Trap',
					138: 'Boulder',
					140: 'Demonite Brick',
					141: 'Explosives',
					142: 'Inlet Pump',
					143: 'Outlet Pump',
					145: 'Candy Cane Block',
					146: 'Green Candy Cane Block',
					147: 'Snow Block',
					148: 'Snow Brick'}
					
	WallIDMapping = {1:"Stone Wall",
					 2: "Dirt Wall",
					 4: "Wood Wall",
					 5: "Gray Brick Wall",
					 6: "Red Brick Wall",
					 7: "Blue Brick Wall",
					 8: "Green Brick Wall",
					 9: "Pink Brick Wall",
					 10: "Gold Brick Wall",
					 11: "Silver Brick Wall",
					 12: "Copper Brick Wall",
					 14: "Obsidian Brick Wall",
					 15: "Mud Wall",
					 16: "Dirt Wall",
					 17: "Blue Brick Wall",
					 18: "Green Brick Wall",
					 19: "Pink Brick Wall",
					 20: "Obsidian Brick Wall",
					 21: "Glass Wall",
					 22: "Pearlstone Brick Wall",
					 23: "Iridescent Brick Wall",
					 24: "Mudstone Brick Wall",
					 25: "Cobalt Brick Wall",
					 26: "Mythril Brick Wall",
					 27: "Planked Wall",
					 29: "Candy Cane Wall",
					 30: "Green Candy Cane Wall",
					 31: "Snow Brick Wall"}
	
	[Getter(Author)]
	public override _Author = "Ijwu"
	
	[Getter(Description)]
	public override _Description = "Allows for creative block picking."
	
	[Getter(Name)]
	public override _Name = "PickBlock"
	
	[Getter(Version)]
	public override _Version = System.Version(1,0,0,0)
	
	public def constructor(game as Main):
		super(game)
	
	public override def Initialize():
		for i in range(255):
			Players[i].pick = false
		
		GetDataHandlers.TileEdit += OnTileEdit
		Commands.ChatCommands.Add(Command("pickblock",PickBlock, "pick"))

	protected def Dispose(disposing as bool):
		if disposing:
			GetDataHandlers.TileEdit -= OnTileEdit
		super.Dispose(disposing)
	   
	    
	private def PickBlock(args as CommandArgs):
		player = Players[args.Player.Index]
		player.pick = true
		Players[args.Player.Index] = player
		args.Player.SendMessage("Hit an object to get a full stack of that object.", Color.Aqua)
		
	private def GiveBlock(playerID as int, editType as byte):
		plr as PickPlayer = Players[playerID]
		picked as Tile = Main.tile[plr.x, plr.y]
		player as TSPlayer = TShock.Players[playerID]
		tiletype as int = picked.type
		walltype as int = picked.wall
		
		if editType in [4,0]:
			item as Item = TShock.Utils.GetItemByIdOrName(TileIDMapping[tiletype])[0]
			player.GiveItem(item.type, item.name, item.width, item.height, item.maxStack, 0)
			
		elif editType == 2:
			wall as Item = TShock.Utils.GetItemByIdOrName(WallIDMapping[walltype])[0]
			player.GiveItem(wall.type, wall.name, wall.width, wall.height, wall.maxStack, 0)
			
		elif editType == 6:
			wire as Item = TShock.Utils.GetItemByIdOrName("Wire")[0]
			player.GiveItem(wire.type, wire.name, wire.width, wire.height, wire.maxStack, 0)
		
		plr.pick = false
		Players[playerID] = plr
		
	
	private def OnTileEdit(sender as Object, args as GetDataHandlers.TileEditEventArgs):
		player = Players[args.Player.Index]
		
		if args.Handled:
			return
	
		player.x = args.X
		player.y = args.Y
		
		Players[args.Player.Index] = player
		
		if player.pick:
			GiveBlock(args.Player.Index, args.EditType)
			args.Handled = true