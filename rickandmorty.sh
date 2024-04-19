#!/bin/bash
#---$(wget -qO "$archivoCacheJson" "$url" | jq "{Id:.id, Name:.name, Status:.status, Species:.species, Gender:.gender, Origin:.origin.name, Location:.location.name}")

archivoCacheJson="archivoCache.json"
$(touch "$archivoCacheJson") #Crear el archivo si no existe, si existe actualiza las marcas de tiempo.

cantidadDeCaracteres=$(wc -m < "$archivoCacheJson")
if [[ $cantidadDeCaracteres -eq 0 ]]; then
    printf "[]" > "$archivoCacheJson"
fi

options=$(getopt -o i:n:h --l help,id:,nombre: -- "$@" 2> /dev/null)
if [ "$?" != "0" ] # equivale a: if test "$?" != "0"
then 
    echo "Opciones incorrectas"
    exit 1
fi
eval set -- "$options"
while true
do 
    case "$1" in
        -i | --id)
            id="$2"
            shift 2
            ;;
        -n | --nombre)
            name="$2"
            shift 2
            ;;
        -h | --help)
            ayuda
            exit 0
            ;;
        --) 
            shift
            break
            ;;
        *) #default: 
            echo "error"
            exit 1
            ;;
    esac 
done

IFS="," #Establece la variable IFS para que la coma (,) sea el separador de campo.
read -ra arrayId <<< "$id"
read -ra arrayName <<< "$name"
IFS=$' \t\n'  # Restaura el IFS predeterminado

url_base="https://rickandmortyapi.com/api/character"

for character_id in "${arrayId[@]}"
do
    character_json=$(echo "$json_data" | jq ".[] | select(.Id == $character_id)")
    if [ -z "$character_json" ];then #pregunto si devolvio vacio ""
        url="$url_base/$character_id"
        response=$(curl -s "$url")
        if [ $? -ne 0 ]; then
            echo "Error: curl request failed"
            exit 1
        fi
        json_data=$(<"$archivoCacheJson")
        response_clean=$(echo "$response" | jq '{Id: .id, Name: .name, Status: .status, Species: .species, Gender: .gender, Origin: .origin.name, Location: .location.name}')
        updated_json_data=$(echo "$json_data" | jq ". + [$response_clean]")
        echo "$updated_json_data" > "$archivoCacheJson"
        echo $response_clean | jq
    else
        echo $character_json | jq
    fi
done