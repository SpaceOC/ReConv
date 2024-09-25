package converter.types;

import converter.dataCharts.Codename;
import converter.dataCharts.Psych;
import converter.other.RawEvent;
import converter.chartsFunctions.PsychEngine;
import converter.other.NotesAndEventsConverts;

class FromPE {
    static private var baseOpponentCSL:CodenameChartStrumLine;
    static private var basePlayerCSL:CodenameChartStrumLine;
    static public var currentPath:String;
    static public var unknownEvents:Array<String> = [];
    static public var impossibleEvents:Array<String> = [];

    static public function toCodename(chart:PsychSwagSong):CodenameChartData {
        baseOpponentCSL = {
            characters: [chart.player2],
            type: 0,
            notes: [],
            position: "dad"
        }
        baseOpponentCSL.notes = NotesConverts.toCodename(chart.notes, false);

        basePlayerCSL = {
            characters: [chart.player1],
            type: 1,
            notes: [],
            position: "boyfriend"
        }
        basePlayerCSL.notes = NotesConverts.toCodename(chart.notes);
        
        __opponentSinglePushNotes(chart);
        __playerSinglePushNotes(chart);
    
        var events:Array<CodenameChartEvent> = [];
        var rawEvents:Array<RawChartEvents> = [];
        if (chart.events != null) {
            events = EventsConverts.toCodename(chart.events, chart.speed);
            unknownEvents = EventsConverts.unknownEvents;
            impossibleEvents = EventsConverts.impossibleEvents;
        }

        for (section in chart.notes) {
            if (section == null) continue;
            for (event in section.sectionNotes) {
                if (section.sectionNotes.length >= 3 && Std.parseInt(event[2]) == null) {
                    rawEvents.push({
                        time: event[0],
                        events: [{
                            name: event[2],
                            param1: event[3],
                            param2: event[4]
                        }]
                    });
                }
            }
        }

        if (FileSystem.exists(currentPath + "/events.json")) {
            var eventsFile:PsychSwagSong = Song.json(currentPath + "/events.json");

            if (eventsFile.events != null) {
                for (event in EventsConverts.toCodename(eventsFile.events, chart.speed))
                    events.push(event);

                for (warn in EventsConverts.unknownEvents)
                    if (!unknownEvents.contains(warn)) unknownEvents.push(warn);

                for (warn in EventsConverts.impossibleEvents)
                    if (!impossibleEvents.contains(warn)) impossibleEvents.push(warn);
            }
            
            if (eventsFile.notes != null) {
                for (section in eventsFile.notes) {
                    if (section == null) continue;
                    for (event in section.sectionNotes) {
                        if (section.sectionNotes.length >= 3 && Std.parseInt(event[2]) == null) {
                            rawEvents.push({
                                time: event[0],
                                events: [{
                                    name: event[2],
                                    param1: event[3],
                                    param2: event[4]
                                }]
                            });
                        }
                    }
                }
            }
        }
           
        var firstSector:Bool = true;
        for (section in chart.notes) {
            if (section == null) continue;
            if (section.sectionNotes.length > 0) {
                events.push({
                    name: "Camera Movement",
                    time: (section.sectionNotes[0][0] - (firstSector ? 0.0 : 0.1)),
                    params: [section.mustHitSection ? 1 : 0]
                });
            }
            if (firstSector) firstSector = false;
        }
    
        var finaleChartData:CodenameChartData = {
            strumLines: [baseOpponentCSL, basePlayerCSL],
            events: events,
            codenameChart: true,
            stage: chart.stage,
            meta: {},
            scrollSpeed: chart.speed,
            noteTypes: NotesConverts.codenameNotesArray
        };

        NotesConverts.codenameNotesArray = [];
        
        return finaleChartData;
    }

    private static function __playerSinglePushNotes(sections:PsychSwagSong):Void {
        for (section in sections.notes) {
            if (section == null) continue;
            if (!section.mustHitSection && section.sectionNotes.length > 0) {
                for (notes in section.sectionNotes) {
                    if (notes[1] > 3) {
                        var noteType:Int = 0;
                        var specialNote:Bool = section.sectionNotes.length > 3 && Std.parseInt(notes[3]) == null && notes[3] != null;
                        if (specialNote) {
                            if (!NotesConverts.codenameNotesArray.contains(notes[3])) NotesConverts.codenameNotesArray.push(notes[3]);
                            noteType = (1 + NotesConverts.codenameNotesArray.indexOf(notes[3]));
                        }
                        if (section.gfSection) {
                            if (!NotesConverts.codenameNotesArray.contains("GF Sing")) NotesConverts.codenameNotesArray.push("GF Sing");
                            noteType = (1 + NotesConverts.codenameNotesArray.indexOf((!specialNote ? "GF Sing" : notes[3])));
                        }
                        basePlayerCSL.notes.push(
                            Reflect.copy({
                                time: (notes[0] != null ? notes[0] : 0.0),
                                id: Std.int((notes[1] - 4)),
                                type: noteType,
                                sLen: (notes[2] != null ? notes[2] : 0.0)
                            })
                        );
                    }
                }
            }
        }
    }
    
    private static function __opponentSinglePushNotes(sections:PsychSwagSong):Void {
        for (section in sections.notes) {
            if (section == null) continue;
            if (section.mustHitSection && section.sectionNotes.length > 0) {
                for (notes in section.sectionNotes) {
                    if (notes[1] > 3) {
                        var noteType:Int = 0;
                        var specialNote:Bool = section.sectionNotes.length > 3 && Std.parseInt(notes[3]) == null && notes[3] != null;
                        if (specialNote) {
                            if (!NotesConverts.codenameNotesArray.contains(notes[3])) NotesConverts.codenameNotesArray.push(notes[3]);
                            noteType = (1 + NotesConverts.codenameNotesArray.indexOf(notes[3]));
                        }
                        if (section.gfSection) {
                            if (!NotesConverts.codenameNotesArray.contains("GF Sing")) NotesConverts.codenameNotesArray.push("GF Sing");
                            noteType = (1 + NotesConverts.codenameNotesArray.indexOf((!specialNote ? "GF Sing" : notes[3])));
                        }
                        baseOpponentCSL.notes.push(
                            Reflect.copy({
                                time: (notes[0] != null ? notes[0] : 0.0),
                                id: Std.int((notes[1] - 4)),
                                type: noteType,
                                sLen: (notes[2] != null ? notes[2] : 0.0)
                            })
                        );
                    }
                }
            }
        }
    }
}