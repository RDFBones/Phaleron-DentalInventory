# Phaleron Dental Inventory
This RDFBones extension implements the dental inventory routine developed and used by the Phaleron Bioarchaeological Project. 

## Dependencies

This RDFBones ontology extension requires the [RDFBones core ontology](https://github.com/RDFBones/RDFBones-O) (version 0.2) to be loaded in the same system in order to work.

Also, the following ontology extensions need to be loaded in addition:

* [Dentalwear](https://github.com/RDFBones/Dentalwear) (version 0.1)
* [DentDev](https://github.com/RDFBones/DentDev) (version 0.1)
* [Phaleron-Pathologies](https://github.com/RDFBones/Phaleron-Pathologies) (version 0.1)
* [Standards-Dental1](https://github.com/RDFBones/Standards-Dental1) (version 0.1)
* [Standards-Pathologies](https://github.com/RDFBones/Standards-Pathologies) (version 0.1)
* [Wearpatterns](https://github.com/RDFBones/Wearpatterns) (version 0.1)

## Compilation from Templates

The [robot](https://github.com/RDFBones/Phaleron-DentalInventory/tree/robot) branch contains a bash script that compiles the Phaleron Dental Inventory ontology extensions from a number of tabular templates. To achieve this, follow the following steps:

1. Clone this repository to your local hard drive.
2. Check out the [robot](https://github.com/RDFBones/Phaleron-DentalInventory/tree/robot) branch.
3. Install [ROBOT](https://robot.obolibrary.org/), a tool for working with OWL files, by following instructions on their website.
4. Navigate to the base folder of your local instance of this repository and run the script [Script_PhaleronDI-Robot.sh](https://github.com/RDFBones/Phaleron-DentalInventory/blob/robot/Script_PhaleronDI-Robot.sh) from the command line. You need to call at least one of the script's options (see below) for it to work.
5. The script will create a new folder 'results' that contains output files according to your chosen options.

The following options can be specified:

**-b** Builds just the ontology extension. Output file: phaleron-di.owl. Use this option if you just want the Phaleron Dental Inventory ontology extension and load the dependency ontlogy extensions separately.

**-c** Cleans up the 'results' folder by only leaving the desired output files in place. Use of this option is generally advised unless you have a specific interest in the temporary files that are created while the ontology extension is compiled.

**-d** Builds the ontology extension and merges in the other ontology extensions that are required (see above). Output file: phaleron-di_dep.owl. Use this option if you want a comprehensive file that works straight away in combination with the core ontology.

**-u** Updates the submodules of this repository to make sure that the script uses the latest versions of the other ontology extensions that are required (see above). Use of this option is generally advised unless you have a specific reason to skip updates to the dependencies.
