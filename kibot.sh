#!/bin/bash

# run this script to generate stuff defined in ./project/.kibot.yaml file
# ./kibot.sh

set -e
uid=$(id -u)
gid=$(id -g)


function run_kibot() {
	time docker run --rm -it \
	--volume "$(pwd):/tmp/workdir" \
	--workdir "/tmp/workdir" \
	setsoft/kicad_auto:ki6.0.10_Debian \
	/bin/bash -c "groupadd -g$gid u; useradd -u$uid -g$gid -d/tmp u; su u -c 'cd project && kibot -c .kibot.yaml $*'"
}

if [ "$1" ]; then
	echo "executing kibot with params: $*"
	run_kibot $*
	exit 0
fi




# regenerate qr code
mkdir -p gen
sch_version="$(grep '\(rev "[^"]*\)"' project/project.kicad_sch | cut -d'"' -f2)"
echo "http://temp-1w8-pro.makerspace.lt/v${sch_version}" \
        | qrencode -o - -l L -m1 -d256 -s5 > gen/qr_link.png

# convert png to footprint as bitmap2component cannot be used from cli
curl -sSL -X POST \
        -F "module_name=qr" \
        -F "threshold=127" \
        -F "scale_factor=0.1" \
        -F "thefile=@gen/qr_link.png" \
        -F "submit=Upload" \
        http://img2mod.wayneandlayne.com/img2mod_process.py \
        > project/lib/footprint/qr.kicad_mod



# generate documentation stuff
run_kibot --out-dir ../gen/

# generate single board fab stuff
mkdir -p gen/single
run_kibot --skip-pre all --out-dir ../gen/single ibom fab_gerbers fab_drill fab_netlist fab_position



# make gerber generation reproducible for git
sed -i \
	-e '/^.*TF.CreationDate.*$/d' \
	-e '/^.*G04 Created by KiCad.* date .*$/d' \
	-e '/^.*DRILL file .* date .*$/d' \
	./gen/*/*.{gbr,drl}

# remove garbage changes from schematics.pdf
sed -i '/[/]CreationDate.*$/d' ./gen/schematics.pdf
sed -i '/[/]CreationDate.*$/d' ./gen/pcb.pdf


# move files around
rm ./gen/*rc.txt

cp -f ./gen/bom.csv ./gen/single/_bom.csv


# archive 

function archive() {
	dir="$(dirname "$1")"
	rm -f $1
	touch -cd 1970-01-01T00:00:00Z $dir/*
	zip -qjorX9 -n zip $1 $dir
}
archive ./gen/single/_prod.zip



