
# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RICK AND MORTY&nbsp;&nbsp;&nbsp;&nbsp;
## INTRODUCCION

Este script proporciona una manera conveniente de buscar información sobre personajes utilizando su ID o nombre a través de la API [Rick And Morty API](https://rickandmortyapi.com/). Puedes especificar uno o más IDs o nombres al ejecutar el script, e incluso solicitar una búsqueda combinada utilizando ambos parámetros.
## REQUERIMIENTOS
Para el funcionamiento de el script se va a necesitar tener instalado el programa JQ
```bash
sudo apt install jq
```
Tambien se va a necesitar tener instalado CURL
```bash
sudo apt install curl
```
Verificar si se tiene instalado
```bash
jq --version
curl --version
```
## PARAMETROS

| Parametro    | Descripción  |
|--------------|--------------|
|  ```-i / --id ```   | Id o ids de los personajes a buscar. | 
| ```-n / --nombre```  |Nombre o nombres de los personajes a buscar. |

### Ejemplo
---
```
$ ./rickandmorty.sh --id “1,2” --nombre “rick, morty”
```
---