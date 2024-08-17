package converter.chartsFunctions;

import StringTools;
import sys.io.File;
import haxe.Json;

import converter.dataCharts.Psych;

using StringTools;

class Song
{
	public static function json(jsonPath:String):PsychSwagSong
	{
		var rawJson:Dynamic = null;
		rawJson = File.getContent(jsonPath).trim();
		if (rawJson == null) {
			trace('Oh no... Its NULL');
			return rawJson;
		}
		return cast Json.parse(rawJson).song;
	}
}
