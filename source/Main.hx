import sys.*;
import converter.Converter;
import StringTools;
import lime.app.Application;

using StringTools;

class Main extends Application
{
	public static function main() {
		FileSystem.createDirectory('ReConvData');
		FileSystem.createDirectory('ReConvData/psych');
		FileSystem.createDirectory('ReConvData/result');
		Sys.print('ReConv by SpaceOC\n');
        Converter.converterStart();
	}
	public function new() {
		super();
	}
}
