import sys
import os

action = sys.argv[1]
name = sys.argv[2]
dir_rtl = "./rtl"
dir_tb = "./tb"
template_module = "./templates/module.v"
template_tb = "./templates/tb.sv"

if action == "-m":
    if os.path.exists(f"{dir_rtl}/{name}.v"):
        print("File exist!")
    else:
        command = f"touch {dir_rtl}/{name}.v"

        with open(template_module, "r") as f:
            content = f.read().replace("name", name)
            with open(f"{dir_rtl}/{name}.v", "w") as f:
                f.write(content)
        
        
elif action == "-t":
    if not os.path.exists(f"{dir_rtl}/{name}.v"):
        print("File not exist!")
    else:
        command = f"touch {dir_tb}/tb_{name}.sv"
        input_signals = []
        output_signals = []
        instance_signal = []
        with open(f"{dir_rtl}/{name}.v", "r") as f:
            content = f.readlines()
            for line in content:
                if "input" in line:
                    instance_signal.append(line.strip().split("\t")[len(line.strip().split("\t"))-1])
                    input_signals.append(line.strip().replace("input wire", "logic").replace(",", "") + ";")
                elif "output" in line:
                    instance_signal.append(line.strip().split("\t")[len(line.strip().split("\t"))-1])
                    output_signals.append(line.strip().replace("output wire", "logic").replace("output reg", "logic").replace(",", "") + ";")
        with open(template_tb, "r") as f:
            input_content = "\n\t".join(input_signals)
            output_content = "\n\t".join(output_signals)
            instance_content = "".join(instance_signal)
            content = f.read().replace("name", name).replace("Input", input_content).replace("Output", output_content).replace("Instance", f"{name} {name}_instance({instance_content})")
            with open(f"{dir_tb}/{name}.sv", "w") as f:
                f.write(content)
elif action == "-s":
    commands = ["vlib work", f"vlog -work work +acc -sv {dir_tb}/{name}.sv", f"vsim -c work.tb_{name} -voptargs=+acc", "rm -rf transcript", "rm -rf *.log work"] 
    for command in commands:
        os.system(command)  
elif action == "-w":
    os.system(f"gtkwave wave_file/tb_{name}.vcd")         