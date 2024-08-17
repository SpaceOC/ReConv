package converter.other;

import converter.dataCharts.Psych;
import converter.dataCharts.Codename;
import converter.chartsFunctions.PsychEngine;
import converter.types.FromPE;

class Reconvert {
    static private var unknownEvents:Array<String> = [];
    static private var impossibleEvents:Array<String> = []; // uh. yeah...
    static public var currentPath:String;

    public static function psychToCodename(songJsonPath:String) {
        var psychEngineChart:PsychSwagSong = Song.json(songJsonPath);
        FromPE.currentPath = currentPath;
        var codenameEngineChart:CodenameChartData = FromPE.toCodename(psychEngineChart);
        unknownEvents = FromPE.unknownEvents;
        impossibleEvents = FromPE.impossibleEvents;

        if (unknownEvents.length > 1) Sys.print('WARNING: Events { $unknownEvents } do not exist in Codename Engine!\n');
        if (impossibleEvents.length > 1) Sys.print('WARNING: Events { $impossibleEvents } cannot be converted normally yet! You will have to modify this event yourself.\n');
        
        var metaCE:CodenameChartMetaData = {
            name: psychEngineChart.song.toLowerCase(),
            displayName: psychEngineChart.song,
            bpm: psychEngineChart.bpm,
            needsVoices: psychEngineChart.needsVoices,
            icon: psychEngineChart.player2,
            difficulties: ["HARD"]
        };
        var sourcePath = 'ReConvData/psych/' + psychEngineChart.song.toLowerCase().replace(' ', '-');
        var songName = psychEngineChart.song.toLowerCase();
        psychEngineChart = null;
        FileSystem.createDirectory('ReConvData/result/' + songName);
        FileSystem.createDirectory('ReConvData/result/' + songName + '/charts');
        FileSystem.createDirectory('ReConvData/result/' + songName + '/scripts');
        FileSystem.createDirectory('ReConvData/result/' + songName + '/song');
        File.write('ReConvData/result/' + songName + '/meta.json');
        File.write('ReConvData/result/' + songName + '/charts/HARD.json');
        File.saveContent('ReConvData/result/' + songName + '/meta.json', Json.stringify(metaCE));
        File.saveContent('ReConvData/result/' + songName + '/charts/HARD.json', Json.stringify(codenameEngineChart));
        metaCE = null;
        codenameEngineChart = null;

        if (!FileSystem.exists(sourcePath + '/Inst.ogg')) Sys.print("WARNING: Inst.ogg not found!\n");
        if (!FileSystem.exists(sourcePath + '/Voices.ogg') && psychEngineChart.needsVoices) Sys.print("WARNING: Voices.ogg not found!\n");

        for (file in FileSystem.readDirectory("./" + sourcePath)) {
            if (file.endsWith(".ogg")) {
                File.copy(sourcePath + '/' + file, 'ReConvData/result/' + songName + '/song/' + file);
            }
        }
    }
}