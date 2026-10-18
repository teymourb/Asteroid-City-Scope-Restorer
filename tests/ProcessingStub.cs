// Synthetic stage fault injector. It deliberately creates partial output on errors.
using System;
using System.IO;
class ProcessingStub {
    static int Main(string[] args) {
        string marker = Environment.GetEnvironmentVariable("STAGE_MARKER");
        int index = File.Exists(marker) ? File.ReadAllLines(marker).Length + 1 : 1;
        File.AppendAllText(marker, "called\n");
        Console.WriteLine("synthetic processing diagnostic");
        string output = args[args.Length - 1];
        for (int i = 0; i < args.Length - 1; i++)
            if (args[i] == "-o" || args[i] == "--save") output = args[i + 1];
        string target = Environment.GetEnvironmentVariable("STAGE_FAIL_AT");
        bool selected = String.IsNullOrEmpty(target) || Int32.Parse(target) == index;
        string kind = selected ? Environment.GetEnvironmentVariable("STAGE_OUTPUT") : "normal";
        if (kind != "missing") {
            Directory.CreateDirectory(Path.GetDirectoryName(output));
            if (kind == "directory") Directory.CreateDirectory(output);
            else File.WriteAllText(output, kind == "empty" ? "" : "synthetic partial output");
        }
        return selected ? Int32.Parse(Environment.GetEnvironmentVariable("STAGE_EXIT")) : 0;
    }
}
