package converter.other;

import converter.other.Reconvert;

typedef SearchChartsListData = {
    var folderPath:String;
    var charts:Array<String>;
}

class Search {
    static private var tempChartsPaths:Array<SearchChartsListData> = [];

    public static function start(path:String):Void {
        __searchCharts(path);
        trace(tempChartsPaths);
        if (tempChartsPaths.length == 0) {
            Sys.print("Please drop the chart folder in the \"psych\" folder along with the .ogg files.\n");
            Sys.exit(-1);
        }
        for (file in tempChartsPaths) {
            Reconvert.currentPath = file.folderPath;
            trace(file);
            for (chart in file.charts)
                Reconvert.psychToCodename(chart);
        }
        tempChartsPaths = null;
    }

    private static function __searchCharts(path:String):Void {
        var passedFolders:Array<String> = [ for (folder in tempChartsPaths) Reflect.copy(folder.folderPath) ];
        for (file in FileSystem.readDirectory(path)) {
            var filePath:String = path + "/" + file;
            if ((FileSystem.isDirectory(path) && path == "ReConvData/result") || ArrayUtils.itWas(path, passedFolders)) 
                continue;

            if (filePath.endsWith(".json") && !filePath.endsWith("dialogue.json") && !filePath.endsWith("events.json")) {
                tempChartsPaths.push({
                    folderPath: path,
                    charts: [filePath]
                });
            }

            else if (FileSystem.isDirectory(filePath))
                __searchCharts(filePath);
        }
    }
}