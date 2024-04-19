#!/bin/bash
# url_base="https://rickandmortyapi.com/api/character"

# url="$url_base/5,6,7,8"
# response=$(curl -s "$url")
# response_clean=$(echo "$response" | jq )

# content=$(<personajes.json)

# # Agregar un nuevo diccionario al contenido JSON usando jq
# updated_content=$(echo "$content" | jq ". + $response_clean") #Por grupo
# updated_content=$(echo "$content" | jq ". + [$response_clean]") #Por personaje


# # Guardar el contenido actualizado de vuelta en el archivo
# echo "$updated_content" > personajes.json


archivoCacheJson="archivoCache.json"
character_id=$1
json_data=$(<"$archivoCacheJson")

patron="\"Id\": $character_id"

character_json=$(echo "$json_data" | jq ".[] | select(.Id == $character_id)")
if [ -z "$character_json" ];then
    echo "No lo encontro"
else
    echo "Lo encontro"
fi

echo $character_json | jq
# echo "$json_data" | jq ".[] | select(.Id == $character_id)"