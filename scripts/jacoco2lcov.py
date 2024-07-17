#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import sys

def parse_counter(counter):
    covered = int(counter.attrib['covered'])
    missed = int(counter.attrib['missed'])
    return covered, missed

def main(input_file, output_file):
    tree = ET.parse(input_file)
    root = tree.getroot()

    with open(output_file, 'w') as f:
        f.write("TN:\n")

        for package in root.findall('package'):
            for sourcefile in package.findall('sourcefile'):
                filename = sourcefile.attrib['name']
                f.write(f'SF:{package.attrib["name"]}/{filename}\n')

                for line in sourcefile.findall('line'):
                    line_number = line.attrib['nr']
                    covered = int(line.attrib['ci'])
                    f.write(f'DA:{line_number},{covered}\n')

                f.write('end_of_record\n')

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    main(input_file, output_file)
