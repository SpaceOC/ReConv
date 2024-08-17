package converter.dataCharts;

typedef PsychSwagSection =
{
	var sectionNotes:Array<Dynamic>;
	var sectionBeats:Float;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var gfSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}

typedef PsychSwagSong =
{
	var song:String;
	var notes:Array<PsychSwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;

	@:optional var gameOverChar:String;
	@:optional var gameOverSound:String;
	@:optional var gameOverLoop:String;
	@:optional var gameOverEnd:String;
	
	@:optional var disableNoteRGB:Bool;

	@:optional var arrowSkin:String;
	@:optional var splashSkin:String;
}