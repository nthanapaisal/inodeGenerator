# inodeGenerator [completed]
    bash scripts help generate number of blocks that make up a file, input can come from a file or stdin
# Execute:
    1. Takes the input from stdin (inodeScriptCommand.bash)
    
    - Execute the script [ $ bash inodeScriptCommand.bash ]
    - Insert the inputs in the command line in this format after the prompt: actualSize fileSize k-BlockSize byteAddress [ $ 4 GB 4 4 ]
    
    2. Takes the input from a file if the user has a list of inputs (main.bash and inodeScriptFile.bash)
    - Input.txt format by line: [ 4 GB 4 4 ]
    - Execute the script [ $ bash main.bash input.txt ]
# notes:
    Scripts can take to file size from bytes up to TB
