package utils;

class ArrayUtils {
    public static function itWas(variable:String, array:Array<String>):Bool {
        if (array == null || array.length < 1) return false;
        for (arrayVariable in array) {
            if (arrayVariable == variable) return true;
        }
        return false;
    }
}