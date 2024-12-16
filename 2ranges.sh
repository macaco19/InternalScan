#!/bin/bash

# rangos1.2.sh: Procesamiento de rangos y detección de IPs vivas

# Configuración inicial
mazorca_dir="mazorca"
loot_dir="$mazorca_dir/loot"
mkdir -p "$mazorca_dir"
mkdir -p "$loot_dir"

# Detectar el archivo de resultados según el rango
read -p "Ingrese la base del rango escaneado (10, 172 o 192): " base
resultados="$loot_dir/script_results-$base"
ips_vivas="$loot_dir/script_IPs_vivas-$base"
rangos_procesados="$loot_dir/rangos_procesados-$base.tmp"

# Verificar si el archivo de resultados existe
if [[ ! -f $resultados ]]; then
    echo "El archivo $resultados no existe. No hay datos para procesar."
    exit 1
fi

# Crear o vaciar los archivos necesarios
> "$ips_vivas"
> "$rangos_procesados"

# Extraer los rangos únicos y procesarlos
echo -e "\033[1;34m[+] Procesando rangos únicos desde $resultados...\033[0m"

awk '{print $4}' "$resultados" | sort -u | sort -t . -k1,1n -k2,2n -k3,3n -k4,4n | while read rango; do
    # Comprobar si ya se procesó este rango
    if grep -q "^$rango$" "$rangos_procesados"; then
        echo -e "\033[1;33m[*] Rango ya procesado: $rango. Omitiendo...\033[0m"
        continue
    fi

    # Escaneo con fping para el rango completo
    echo -e "\033[1;34m[*] Escaneando rango completo: $rango...\033[0m"
    fping -ag "$rango" 2>/dev/null >> "$ips_vivas"

    # Guardar el rango como procesado
    echo "$rango" >> "$rangos_procesados"
    echo -e "\033[1;32m[+] Rango procesado: $rango\033[0m"
done

echo -e "\033[1;33m[+] Procesamiento completo. IPs vivas guardadas en $ips_vivas.\033[0m"
