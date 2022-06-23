#! /bin/bash

## DEFINE OPTIONS

cleanup=0
update=0
build=0
dependencies=0

function usage {
    echo " "
    echo "usage: $0 [-b][-c][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -c          cleanup temp files"
    echo "    -d          add required ontology extensions to owl file"
    echo "    -u          initalize/update submodule"
    echo "    -h -?       print this help"
    echo " "
    
    exit
}

while getopts "bcduh?" opt; do
    case "$opt" in
	
        c)
            cleanup=1
            ;;
	
	u)
	    update=1
	    ;;
	
	b)
	    build=1
	    ;;
	
	d)
	    dependencies=1
	    ;;
	
	?)
	    usage
	    ;;
	
	h)
	    usage
	    ;;
	
    esac
done

if [ -z "$1" ]; then
    
    usage
    
fi

## PREPARE SUBMODULES

## Check if submodules are initialised

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ];then
    update=1
    echo "Initializing git submodule"
fi

## Initialise and update git submodules

if  [ $update -eq 1 ]; then
    git submodule init
    git submodule update
fi

## BUILD DEPENDENCIES

if [ $build -eq 1 ] || [ $dependencies -eq 1 ]; then

    
## Build Core Ontology

cd RDFBones-O/robot

./Script-Build_RDFBones-Robot.sh

cd ../..


## Build Dentalwear Ontology

cd Dentalwear

./Script_Dentalwear-Robot.sh -b -u

cd ..


## Build DentDev Ontology

cd DentDev

./Script_DentDev-Robot.sh -b -u

cd ..


## Build Standards-Pathologies Ontology
   
cd Standards-Pathologies

./Script_StandardsPatho-Robot.sh -b -c -u

cd ..


## Build Standards-Dental1 Ontology

cd Standards-Dental1

./Script_StandardsDental1-Robot.sh -b -u

cd ..


## Build Phaleron-Pathologies Ontology

cd Phaleron-Pathologies

./Script_PhaleronPatho-Robot.sh -b -c -u

cd ..


## Build Wearpatterns Ontology

cd Wearpatterns

./Script_Wearpatterns-Robot.sh -b -u

cd ..


## MERGE DEPENDENCIES

robot merge --input ./RDFBones-O/robot/results/rdfbones.owl \
      --input ./Dentalwear/results/dentalwear.owl \
      --input ./DentDev/results/dentdev.owl \
      --input ./Phaleron-Pathologies/results/phaleron-patho.owl \
      --input ./Standards-Dental1/results/standards-dental1.owl \
      --input ./Standards-Pathologies/results/standards-patho.owl \
      --input ./Wearpatterns/results/wearpatterns.owl \
      --output results/merged_dependencies.owl


## CREATE VALUE SPECIFICATIONS

robot template --template Template_PhaleronDI-ValueSpecifications.tsv \
      --input results/merged_dependencies.owl \
      --prefix "dentalwear: http://w3id.org/rdfbones/ext/dentalwear/" \
      --prefix "dentdev: http://w3id.org/rdfbones/ext/dentdev/" \
      --prefix "fma: http://purl.org/sig/ont/fma/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "phaleron-di: http://w3id.org/rdfbones/ext/phaleron-di/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "standards-si: http://w3id.org/rdfbones/ext/standards-si/" \
      --prefix "wearpatterns: http://w3id.org/rdfbones/ext/wearpatterns/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-di/latest/phaleron-di.owl" \
      --output results/valuespecs.owl


## CREATE MEASUREMENT DATA

## Compile input

robot merge --input results/merged_dependencies.owl \
      --input results/valuespecs.owl \
      --output results/merged_valuespecs.owl


## Compile template

robot template --template Template_PhaleronDI-MeasurementData.tsv \
      --input results/merged_valuespecs.owl \
      --prefix "dentalwear: http://w3id.org/rdfbones/ext/dentalwear/" \
      --prefix "dentdev: http://w3id.org/rdfbones/ext/dentdev/" \
      --prefix "fma: http://purl.org/sig/ont/fma/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "phaleron-di: http://w3id.org/rdfbones/ext/phaleron-di/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "standards-si: http://w3id.org/rdfbones/ext/standards-si/" \
      --prefix "wearpatterns: http://w3id.org/rdfbones/ext/wearpatterns/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-di/latest/phaleron-di.owl" \
      --output results/measurementdata.owl

    
## CREATE DATASETS

## Compile input

robot merge --input results/merged_valuespecs.owl \
      --input results/measurementdata.owl \
      --output results/merged_measurementdata.owl


## Compile template

robot template --template Template_PhaleronDI-Datasets.tsv \
      --input results/merged_measurementdata.owl \
      --prefix "dentalwear: http://w3id.org/rdfbones/ext/dentalwear/" \
      --prefix "dentdev: http://w3id.org/rdfbones/ext/dentdev/" \
      --prefix "fma: http://purl.org/sig/ont/fma/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "phaleron-di: http://w3id.org/rdfbones/ext/phaleron-di/" \
      --prefix "phaleron-patho: http://w3id.org/rdfbones/ext/phaleron-patho/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "standards-patho: http://w3id.org/rdfbones/ext/standards-patho/" \
      --prefix "standards-si: http://w3id.org/rdfbones/ext/standards-si/" \
      --prefix "wearpatterns: http://w3id.org/rdfbones/ext/wearpatterns/" \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-di/latest/phaleron-di.owl" \
      --output results/datasets.owl


## COMPILE EXTENSION

robot merge --input results/valuespecs.owl \
      --input results/measurementdata.owl \
      --input results/datasets.owl \
      --output results/phaleron-di.owl

robot annotate --input results/phaleron-di.owl \
      --remove-annotations \
      --ontology-iri "http://w3id.org/rdfbones/ext/phaleron-di/latest/phaleron-di.owl" \
      --version-iri "http://w3id.org/rdfbones/ext/phaleron-di/v0-1/phaleron-di.owl" \
      --annotation dc:creator "Felix Engel" \
      --annotation dc:creator "Stefan Schlager" \
      --annotation owl:versionInfo "0.1" \
      --language-annotation dc:description "This RDFBones extension implements the dental inventory routine developed and used by the Phaleron Bioarchaeological Project." en \
      --language-annotation dc:title "Dental Inventory" en \
      --language-annotation rdfs:label "Phaleron dental inventory" en \
      --language-annotation rdfs:comment "The RDFBones core ontology, version 0.2 or later, needs to be loaded into the same information system for this ontology extension to work. Also required are the following ontology extensions: Dentalwear (version 0.1), DentDev (version 0.1), Phaleron-Pathologies (version 0.1), Standards-Dental1 (version 0.1), Standards-Pathologies (version 0.1) and Wearpatterns (version 0.1)." en \
      --output results/phaleron-di.owl


## Quality Check

robot reason --reasoner ELK \
      --input results/phaleron-di.owl \
      -D results/debug_phaleron-di.owl


fi # Ends build process


if  [ $dependencies -eq 1 ]; then # Starts merge of dependencies

    robot merge --input results/phaleron-di.owl \
      --input ./Dentalwear/results/dentalwear.owl \
      --input ./DentDev/results/dentdev.owl \
      --input ./Phaleron-Pathologies/results/phaleron-patho.owl \
      --input ./Standards-Dental1/results/standards-dental1.owl \
      --input ./Standards-Pathologies/results/standards-patho.owl \
      --input ./Wearpatterns/results/wearpatterns.owl \
      --output results/phaleron-di_dep.owl

    ## Quality Check

    robot reason --reasoner ELK \
	  --input results/phaleron-di.owl \
	  -D results/debug_phaleron-di_dep.owl


fi # Ends merge of dependencies



if  [ $cleanup -eq 1 ]; then # Starts cleanup process

    ## CLEANUP

    rm results/datasets.owl
    rm results/measurementdata.owl
    rm results/merged_dependencies.owl
    rm results/merged_measurementdata.owl
    rm results/merged_valuespecs.owl
    rm results/valuespecs.owl

    if [ $dependencies -eq 1 ]; then

	rm results/phaleron-di.owl

    fi
    

fi # Ends cleanup process
