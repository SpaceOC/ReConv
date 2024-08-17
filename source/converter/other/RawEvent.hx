package converter.other;

typedef RawChartEvents = {
    var time:Float;
    var events:Array<RawEvent>;
};

typedef RawEvent = {
    var name:String;
    @:optional var param1:Null<Dynamic>;
    @:optional var param2:Null<Dynamic>;
};