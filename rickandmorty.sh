#!/bin/bash
archivoCacheJson="archivoCache.json" # Nombre del archivo que sera usado como "cache"
$(touch "$archivoCacheJson")         #Crear el archivo si no existe, si existe actualiza las marcas de tiempo.

cantidadDeCaracteres=$(wc -m <"$archivoCacheJson")
if [[ $cantidadDeCaracteres -eq 0 ]]; then
    printf "[]" >"$archivoCacheJson"
fi

url_base="https://rickandmortyapi.com/api/character" # URL base de la API
json_data=$(<"$archivoCacheJson")                    # Abro el archivo y lo coloco en una variable

options=$(getopt -o i:n:h --l help,id:,nombre: -- "$@" 2>/dev/null)
if [ "$?" != "0" ]; then # equivale a: if test "$?" != "0"
    echo "Opciones incorrectas"
    exit 1
fi
eval set -- "$options"
while true; do
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

IFS=","                       #Establece la variable IFS para que la coma (,) sea el separador de campo.
read -ra arrayId <<<"$id"     # Parseo los id y los coloco en un array
read -ra arrayName <<<"$name" # Parseo los nombre y los coloco en un array
IFS=$' \t\n'                  # Restaura el IFS predeterminado

function_search_by_id() {

    echo "Entre aca"
    for character_id in "${arrayId[@]}"; do                                                 # Recorro los ids y busco por Id
        local character_json=$(echo "$json_data" | jq ".[] | select(.Id == $character_id)") # Busco el id en el archivo cache
        if [ -z "$character_json" ]; then                                                   #pregunto si devolvio vacio "", si devuelve vacio hago un get, si no lo muestro por pantalla
            local url="$url_base/$character_id"
            local response=$(curl -s "$url")
            if [ $? -ne 0 ]; then # Pregunto si el ultimo codigo dio algun error
                echo "Error: curl request failed"
                exit 1
            fi
            local response_clean=$(echo "$response" | jq '{Id: .id, Name: .name, Status: .status, Species: .species, Gender: .gender, Origin: .origin.name, Location: .location.name}')
            local updated_json_data=$(echo "$json_data" | jq ". + [$response_clean]")
            echo "$updated_json_data" >"$archivoCacheJson"
            echo "Character info:"
            echo $response_clean | jq
        else
            echo "Character info:"
            echo $character_json | jq
        fi
    done
}
function_search_by_name() {

    for character_name in "${arrayName[@]}"; do # Si no se enviaron id busco por nombre
        local character_json=$(echo "$json_data" | jq --arg initial "$character_name" 'map(select(.Name | ascii_downcase | contains( $initial | ascii_downcase )))')
        local is_empty=$(echo "$character_json" | jq 'length == 0')
         if [ "$is_empty" = "true" ]; then #pregunto si devolvio una lista vacia [], si dio vacio busco por la api, si no lo muestro por pantalla
            local url="$url_base/?name=$character_name"
            local response=$(curl -s "$url")
            if [ $? -ne 0 ]; then # Pregunto si el ultimo codigo dio algun error
                echo "Error: curl request failed"
                exit 1
            fi
            local response_clean=$(echo $response | jq ".results | map({Id: .id, Name: .name, Status: .status, Species: .species, Gender: .gender, Origin: .origin.name, Location: .location.name})")
            local list_length=$(echo "$response_clean" | jq 'length')
            if [ "$list_length" -gt 1 ]; then # Pregunto si se devolvio una lista con mas de un elemento
                local updated_json_data=$(echo "$json_data" | jq ". + $response_clean")
            else
                local updated_json_data=$(echo "$json_data" | jq ". + [$response_clean]")
            fi
            echo "$updated_json_data" >"$archivoCacheJson"
            echo "Character info:"
            echo $response_clean | jq
        else
            echo "Character info:"
            echo $character_json | jq
        fi
    done
}

if ! [ ${#arrayName[@]} -eq 0 ]; then   # Pregunto si se envio nombres
    if ! [ ${#arrayId[@]} -eq 0 ]; then # Pregunto si ademas se envio Ids
        function_search_by_id
    else # Si no se envio id entonces busco solo por nombre
        function_search_by_name
    fi
elif ! [ ${#arrayId[@]} -eq 0 ]; then # Pregunto si se envio Ids
    function_search_by_id
else
    echo "No se ha enviado ningun parametro"
fi
