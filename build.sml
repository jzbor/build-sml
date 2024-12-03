val sourceDirectory = "./src";

fun sort [] = []
  | sort (x::[]) = [x]
  | sort (x::y::[]) = if String.< (x, y) then [x, y] else [y, x]
  | sort (xs) = let
    val split = (xs, ((length xs) div 2));
    val sortedL = sort (List.take split)
    val sortedR = sort (List.drop split)
    fun merge l [] = l
      | merge [] r = r
      | merge (xl::l) (xr::r) = if xl < xr
               then xl::(merge l (xr::r))
               else xr::(merge (xl::l) r)
in
  merge sortedL sortedR
end;

fun subdirs dir = case Posix.FileSys.readdir dir of
                       SOME sub => sub::(subdirs dir)
                     | NONE => [];

fun listFiles path = let
  val dir = Posix.FileSys.opendir path;
  val subs = (subdirs dir) before (Posix.FileSys.closedir dir);
  val subpaths = map (fn d => path ^ "/" ^ d) subs;
  val (dirs, files) = List.partition OS.FileSys.isDir (sort subpaths);
in
  (List.concat (map listFiles dirs))@files
end;

fun listSMLFiles path = List.filter (String.isSuffix ".sml") (listFiles path);

val parent = let
  val full = (OS.FileSys.fullPath (CommandLine.name ()));
  val components = String.tokens (fn c => c = #"/") full;
  val parentComponents = List.take (components, List.length components - 1);
in
  List.foldr (fn (comp, path) => path ^ "/" ^ comp) "/" parentComponents
end;

app use (listSMLFiles sourceDirectory)
