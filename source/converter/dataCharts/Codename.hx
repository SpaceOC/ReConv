package converter.dataCharts;

typedef CodenameChartData = {
	var strumLines:Array<CodenameChartStrumLine>;
	var events:Array<CodenameChartEvent>;
	var meta:CodenameChartMetaData;
	var codenameChart:Bool;
    var stage:String;
	var scrollSpeed:Float;
    var noteTypes:Array<String>;
}

typedef CodenameChartMetaData = {
	@:optional var name:String;
	@:optional var displayName:String;
	@:optional var bpm:Float;
	@:optional var needsVoices:Bool;
	@:optional var icon:String;
	@:optional var difficulties:Array<String>;
}

typedef CodenameChartStrumLine = {
	var characters:Array<String>;
	var type:Int;
	var notes:Array<CodenameChartNote>;
	var position:String;
	@:optional var visible:Bool;
	@:optional var strumPos:Array<Float>;
	@:optional var strumScale:Float;
	@:optional var scrollSpeed:Float;
	@:optional var vocalsSuffix:String;
}

typedef CodenameChartNote = {
	var time:Float;
	var id:Int;
	var type:Int;
	var sLen:Float;
}

typedef CodenameChartEvent = {
	var name:String;
	var time:Float;
	var params:Array<Dynamic>;
}