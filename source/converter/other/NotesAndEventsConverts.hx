package converter.other;

import converter.dataCharts.Codename;
import converter.dataCharts.Psych;
import converter.other.RawEvent;

class NotesConverts {
    public static function toCodename(sections:Array<PsychSwagSection>, ?player:Bool = true):Array<CodenameChartNote> {
        var temp:Array<CodenameChartNote> = [];
        for (section in sections) {
            if (section == null) continue;
            // player = mustHitSection!
            var hitSection:Bool = (player ? section.mustHitSection : !section.mustHitSection);
            if (hitSection && section.sectionNotes.length > 0) {
                for (notes in section.sectionNotes) {
                    if (notes[1] < 4) {
                        temp.push(
                            Reflect.copy({
                                time: (notes[0] != null ? notes[0] : 0.0),
                                id: Std.int((notes[1])),
                                type: 0,
                                sLen: (notes[2] != null ? notes[2] : 0.0)
                            })
                        );
                    }
                }
            }
        }
        return temp;
    }
}

class EventsConverts {
    public static var unknownEvents:Array<String> = [];
    public static var impossibleEvents:Array<String> = [];
    static private var chartSpeed:Float = 0.0;

    private static function __rawEventsToCodename(rawEvents:Array<RawChartEvents>):Array<CodenameChartEvent> {
        var events:Array<CodenameChartEvent> = [];
        for (rawEvent in rawEvents) {
            for (event in rawEvent.events) {
                if (event.name == "Add Camera Zoom") {
                    if (event.param1 != "" && event.param2 != "") {
                        events.push({
                            name: "Add Camera Zoom",
                            time: rawEvent.time,
                            params: [Std.parseFloat(event.param1), "camGame"]
                        });

                        events.push({
                            name: "Add Camera Zoom",
                            time: rawEvent.time,
                            params: [Std.parseFloat(event.param2), "camGame"]
                        });
                    }
                    else if(event.param1 == "" && event.param2 == "") {
                        events.push({
                            name: "Add Camera Zoom",
                            time: rawEvent.time,
                            params: [0.05, "camGame"]
                        });

                        events.push({
                            name: "Add Camera Zoom",
                            time: rawEvent.time,
                            params: [0.05, "camHUD"]
                        });
                    }
                    else {
                        var who:Dynamic = [(event.param1 != "" ? "camGame" : "camHUD")];
                        var floatParam:Float = (event.param1 != "" ? Std.parseFloat(event.param1) : Std.parseFloat(event.param2));
                        events.push({
                            name: "Add Camera Zoom",
                            time: rawEvent.time,
                            params: [floatParam, who]
                        });
                    }
                }
                else if (event.name == "Change Scroll Speed") {
                    events.push({
                        name: "Scroll Speed Change",
                        time: rawEvent.time,
                        params: [true, chartSpeed * event.param1, 4 * event.param2, "linear", "In"]
                    });
                }
                else if (event.name == "Play Animation") {
                    events.push({
                        name: event.name,
                        time: rawEvent.time,
                        params: [(event.param2 == "bf" ? 1 : 0), event.param1, false]
                    });
                }
                else {
                    if (!ArrayUtils.itWas(event.name, unknownEvents)) unknownEvents.push(event.name);
                    events.push({
                        name: event.name,
                        time: rawEvent.time,
                        params: [event.param1, event.param2]
                    });
                }
            }
        }
        return events;
    }

    public static function toCodename(events:Array<Dynamic>, chartSpeed:Float):Array<CodenameChartEvent> {
        var rawEvents:Array<RawChartEvents> = [];
        for (notRaw in events) {
            rawEvents.push({
                time: notRaw[0],
                events: notRaw[1].map(function(subArray) {
                    return {
                        name: subArray[0],
                        param1: subArray.length > 1 ? cast subArray[1] : null,
                        param2: subArray.length > 2 ? cast subArray[2] : null
                    };
                })
            });
        }
        return __rawEventsToCodename(rawEvents);
    }
}