LANGUAGE="EN"
THEME="Default"
SIZE="80x24"

LOG_FILE="program.log"

function log_action() {
    local action_message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        display_message "Log file does not exist. Creating a new log file." "日誌文件不存在。正在創建新日誌文件。" "El archivo de registro no existe. Creando un nuevo archivo de registro."
        touch "$LOG_FILE"
    fi
    echo "[$timestamp] $action_message" >> "$LOG_FILE"
}

function view_log() {
    display_message "Displaying log file contents:" "顯示日誌文件內容：" "Mostrando el contenido del archivo de registro:"

    display_message "Do you want to continue? (y/n):" "是否繼續？(y/n)：" "¿Quieres continuar? (s/n):"
    read continue
    if [ "$continue" != "y" ]; then
        display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
        log_action "Program exited."
        exit 0
    fi
    clear
}

function clear_log() {
    display_message "Clearing log file contents..." "清除日誌文件內容..." "Borrando el contenido del archivo de registro..."
    > "$LOG_FILE"
    display_message "Log file cleared." "日誌文件已清除。" "Archivo de registro borrado."

    display_message "Do you want to continue? (y/n):" "是否繼續？(y/n)：" "¿Quieres continuar? (s/n):"
    read continue
    if [ "$continue" != "y" ]; then
        display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
        log_action "Program exited."
        exit 0
    fi
    clear
}

function set_language() {
    echo "============================="
    echo "Please select a language:"
    echo "請選擇語言："
    echo "Por favor seleccione un idioma:"
    echo "1) English"
    echo "2) 中文"
    echo "3) Español"
    echo "============================="
    read lang_choice
    case $lang_choice in
        1) LANGUAGE="EN" ;;
        2) LANGUAGE="ZH" ;;
        3) LANGUAGE="ES" ;;
        *) echo "Invalid choice. Defaulting to English."; LANGUAGE="EN" ;;
    esac
    display_message "Language updated!" "語言已更新！" "¡Idioma actualizado!"
    log_action "Language updated to $LANGUAGE"
}

function change_terminal_colors() {
    echo "Select a color scheme:"
    echo "1) Default (White text on black background)"
    echo "2) Solarized (Bright colors)"
    echo "3) Monokai (Subtle dark)"
    echo "4) Custom (Enter your own colors)"
    read color_choice
    case $color_choice in
        1)
            echo -e "\033[0m"  # 重置為默認
            THEME="Default"
            ;;
        2)
            echo -e "\033[38;5;230m\033[48;5;235m"  # Solarized
            THEME="Solarized"
            ;;
        3)
            echo -e "\033[38;5;223m\033[48;5;233m"  # Monokai
            THEME="Monokai"
            ;;
        4)
            echo "Enter text color (0-255):"
            read text_color
            echo "Enter background color (0-255):"
            read bg_color
            echo -e "\033[38;5;${text_color}m\033[48;5;${bg_color}m"
            THEME="Custom"
            ;;
        *)
            display_message "Invalid choice. No changes made." "無效的選擇。未進行更改。" "Opción inválida. No se realizaron cambios."
            ;;
    esac
    display_message "Terminal colors updated!" "終端機顏色已更新！" "¡Colores del terminal actualizados!"
    log_action "Terminal colors updated to $THEME"
}

function resize_terminal() {
    echo "Enter the number of rows (height):"
    read rows
    echo "Enter the number of columns (width):"
    read cols
    if command -v resize &> /dev/null; then
        resize -s "$rows" "$cols"
    else
        echo -e "\033[8;${rows};${cols}t"
    fi
    SIZE="${rows}x${cols}"
    display_message "Terminal size updated to ${rows}x${cols}!" "終端機大小已調整為 ${rows}x${cols}！" "¡Tamaño del terminal actualizado a ${rows}x${cols}!"
    log_action "Terminal size updated to ${rows}x${cols}"
}

function show_current_settings() {
    echo "============================="
    display_message "Current Settings:" "當前設置：" "Configuraciones actuales:"
    echo "============================="
    display_message "Language: $LANGUAGE" "語言：$LANGUAGE" "Idioma: $LANGUAGE"
    display_message "Terminal Theme: $THEME" "終端機主題：$THEME" "Tema del terminal: $THEME"
    display_message "Terminal Size: $SIZE" "終端機大小：$SIZE" "Tamaño del terminal: $SIZE"
    display_message "Current Time: $(date)" "當前時間：$(date)" "Hora actual: $(date)"
    echo "============================="
    read -p "Press Enter to return to the options menu..."
}

function display_message() {
    local en_message="$1"
    local zh_message="$2"
    local es_message="$3"
    if [ "$LANGUAGE" == "EN" ]; then
        echo "$en_message"
    elif [ "$LANGUAGE" == "ZH" ]; then
        echo "$zh_message"
    elif [ "$LANGUAGE" == "ES" ]; then
        echo "$es_message"
    fi
}

function show_menu_page() {
    local page=$1
    if [ "$LANGUAGE" == "EN" ]; then
        echo "============================="
        echo " Dynamic Image Tool"
        echo "============================="
        if [ "$page" == "1" ]; then
            echo "1-5) Image Processing:"
            echo "  1) Convert image format"
            echo "  2) Resize image"
            echo "  3) Rotate image"
            echo "  4) Crop image"
            echo "  5) Merge images"
            echo "  6) Apply filters"
        elif [ "$page" == "2" ]; then
            echo "7-10) Animation Processing:"
            echo "  7) Split GIF/MP4 into frames"
            echo "  8) Split sprite sheet"
            echo "  9) Create animation (MP4/GIF)"
            echo "  10) Preview animation"
            echo "11-12) Others:"
            echo "  11) Batch process images"
            echo "  12) Check file vaildity"
        elif [ "$page" == "3" ]; then
            echo "13-17) System Options:"
            echo " 13) Options"
            echo " 14) View Log"
            echo " 15) Clear Log"
            echo " 16) Help"
            echo " 17) Save and Exit"
        fi
        echo "============================="
        echo "Please select an option (or 'n' for next page, 'p' for previous page):"
    elif [ "$LANGUAGE" == "ZH" ]; then
        echo "============================="
        echo " 動態圖像工具"
        echo "============================="
        if [ "$page" == "1" ]; then
            echo "1-5) 圖像處理："
            echo "  1) 轉換圖像格式"
            echo "  2) 調整圖像大小"
            echo "  3) 旋轉圖像"
            echo "  4) 裁剪圖像"
            echo "  5) 合併圖像"
            echo "  6) 應用濾鏡"
        elif [ "$page" == "2" ]; then
            echo "7-10) 動畫處理："
            echo "  7) 拆分 GIF/MP4 成幀"
            echo "  8) 拆分精靈圖"
            echo "  9) 創建動畫 (MP4/GIF)"
            echo "  10) 預覽動畫"
            echo "11-12) 其他："
            echo "  11) 批量處理圖像"
            echo "  12) 檢查文件有效性"
        elif [ "$page" == "3" ]; then
            echo "13-17) 系統選項："
            echo " 13) 選項"
            echo " 14) 查看日誌"
            echo " 15) 清除日誌"
            echo " 16) 幫助"
            echo " 17) 保存並退出"
        fi
        echo "============================="
        echo "請選擇一個選項（或 'n' 進入下一頁，'p' 返回上一頁）:"
    elif [ "$LANGUAGE" == "ES" ]; then
        echo "============================="
        echo " Herramienta de Imagen Dinámica"
        echo "============================="
        if [ "$page" == "1" ]; then
            echo "1-5) Procesamiento de Imágenes:"
            echo "  1) Convertir formato de imagen"
            echo "  2) Cambiar tamaño de imagen"
            echo "  3) Rotar imagen"
            echo "  4) Recortar imagen"
            echo "  5) Fusionar imágenes"
            echo "  6) Aplicar filtros"
        elif [ "$page" == "2" ]; then
            echo "7-10) Procesamiento de Animaciones:"
            echo "  7) Dividir GIF/MP4 en cuadros"
            echo "  8) Dividir hoja de sprites"
            echo "  9) Crear animación (MP4/GIF)"
            echo "  10) Previsualizar animación"
            echo "11-12) Otros:"
            echo "  11) Procesar imágenes por lotes"
            echo "  12) Comprobar validez del archivo"
        elif [ "$page" == "3" ]; then
            echo "13-17) Opciones del Sistema:"
            echo "  13) Opciones"
            echo "  14) Ver Log"
            echo "  15) Borrar Log"
            echo "  16) Ayuda"
            echo "  17) Guardar y Salir"
        fi
        echo "============================="
        echo "Por favor seleccione una opción (o 'n' para la siguiente página, 'p' para la página anterior):"
    fi
}

function show_menu() {
    local page=1
    while true; do
        show_menu_page $page
        read choice
        case $choice in
            1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17)
                return $choice
                ;;
            n)
                if [ $page -lt 3 ]; then
                    clear
                    page=$((page + 1))
                fi
                ;;
            p)
                if [ $page -gt 1 ]; then
                clear
                    page=$((page - 1))
                fi
                ;;
            *)
                clear
                display_message "Invalid choice. Please try again." "無效的選擇。請再試一次。" "Opción inválida. Por favor intente de nuevo."
                ;;
        esac
    done
}

function validate_file_path() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        log_action "Error: File not found - $file_path"
        clear
        display_message "Error: File not found. Returning to main menu." "錯誤：文件未找到。返回主菜單。" "Error: Archivo no encontrado. Volviendo al menú principal."
        return 1
    fi
    return 0
}

function vaildate_directory() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        log_action "Error: Directory not found - $dir_path"
        clear
        display_message "Error: Directory not found. Returning to main menu." "錯誤：目錄未找到。返回主菜單。" "Error: Directorio no encontrado. Volviendo al menú principal."
        return 1
    fi
    return 0
}

function execute_command() {
    local command="$1"
    local success_message="$2"
    local error_message="$3"

    if eval "$command"; then
        display_message "$success_message" "操作成功完成！" "¡Operación completada con éxito!"
        log_action "$success_message"
    else
        display_message "$error_message" "操作失敗！請查看日誌文件。" "¡Operación fallida! Por favor, revise el archivo de registro."
        log_action "$error_message"
    fi

    display_message "Do you want to continue? (y/n):" "是否繼續？(y/n)：" "¿Quieres continuar? (s/n):"
    read continue
    if [ "$continue" != "y" ]; then
        display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
        log_action "Program exited."
        exit 0
    fi
    clear
}

function split_gif_mp4() {
    display_message "Enter the path of the GIF/MP4 file:" "請輸入 GIF/MP4 文件路徑：" "Ingrese la ruta del archivo GIF/MP4:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output directory for frames:" "請輸入幀輸出目錄：" "Ingrese el directorio de salida para los cuadros:"
    read output_dir
    mkdir -p "$output_dir"
    command="python3 video_processor.py split_gif_mp4 \"$input_file\" \"$output_dir\""
    execute_command "$command" "Split $input_file into frames in $output_dir" "Failed to split $input_file into frames."
    log_action "Split $input_file into frames in $output_dir"
}

function split_sprite_sheet() {
    display_message "Enter the sprite sheet file path:" "請輸入精靈圖文件路徑：" "Ingrese la ruta del archivo de la hoja de sprites:"
    read sprite_file
    validate_file_path "$sprite_file" || return
    display_message "Enter the number of rows and columns (e.g., 4 4):" "請輸入行數和列數 (如 4 4)：" "Ingrese el número de filas y columnas (por ejemplo, 4 4):"
    read rows cols
    display_message "Enter the output directory for frames:" "請輸入輸出目錄：" "Ingrese el directorio de salida:"
    read output_dir
    mkdir -p "$output_dir"
    command="python3 video_processor.py split_sprite_sheet \"$sprite_file\" \"$rows\" \"$cols\" \"$output_dir\""
    execute_command "$command" "Split sprite sheet $sprite_file into $rows x $cols frames in $output_dir" "Failed to split sprite sheet $sprite_file."
    log_action "Split sprite sheet $sprite_file into $rows x $cols frames in $output_dir"
}

function create_animation() {
    display_message "Enter the directory containing frames:" "請輸入幀目錄：" "Ingrese el directorio que contiene los cuadros:"
    read frames_dir
    if [ ! -d "$frames_dir" ]; then
        log_action "Error: Directory not found - $frames_dir"
        display_message "Error: Directory not found. Returning to main menu." "錯誤：目錄未找到。返回主菜單。" "Error: Directorio no encontrado. Volviendo al menú principal."
        return
    fi
    display_message "Enter the output file name (e.g., output.mp4):" "請輸入輸出文件名 (如 output.mp4)：" "Ingrese el nombre del archivo de salida (por ejemplo, output.mp4):"
    read output_file
    command="python3 video_processor.py create_animation \"$frames_dir\" \"$output_file\""
    execute_command "$command" "Created animation $output_file from frames in $frames_dir" "Failed to create animation $output_file."
    log_action "Created animation $output_file from frames in $frames_dir"
}

function apply_filters() {
    display_message "Enter the input image file:" "請輸入輸入影像文件：" "Ingrese el archivo de imagen de entrada:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output image file:" "請輸入輸出影像文件：" "Ingrese el archivo de imagen de salida:"
    read output_file
    display_message "Select a filter to apply:" "選擇要應用的濾鏡：" "Seleccione un filtro para aplicar:"
    display_message "1) Grayscale" "1) 灰階" "1) Escala de grises"
    display_message "2) Invert" "2) 反轉" "2) Invertir"
    display_message "3) Blur" "3) 模糊" "3) Desenfocar"
    display_message "4) Edge Enhance" "4) 邊緣增強" "4) Mejora de bordes"
    display_message "5) Emboss" "5) 浮雕" "5) Relieve"
    display_message "6) Smooth" "6) 平滑" "6) Suave"
    display_message "7) Sharpen" "7) 銳化" "7) Afilado"
    read filter_choice
    command="python3 image_processor.py apply_filter \"$input_file\" \"$output_file\" \"$filter_choice\""
    execute_command "$command" "Applied filter to $input_file and saved as $output_file" "Failed to apply filter to $input_file."
    log_action "Applied filter to $input_file and saved as $output_file"
}

function preview_animation() {
    display_message "Enter the file name of the animation to preview:" "請輸入要預覽的動畫文件名：" "Ingrese el nombre del archivo de animación para previsualizar:"
    read preview_file
    validate_file_path "$preview_file" || return
    command="xdg-open \"$preview_file\""
    execute_command "$command" "Previewed animation $preview_file" "Failed to preview animation $preview_file."
    log_action "Previewed animation $preview_file"
}

function convert_image_format() {
    display_message "Enter the input image file:" "請輸入輸入影像文件：" "Ingrese el archivo de imagen de entrada:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output image file:" "請輸入輸出影像文件：" "Ingrese el archivo de imagen de salida:"
    read output_file
    command="python3 image_processor.py convert \"$input_file\" \"$output_file\""
    execute_command "$command" "Converted image format from $input_file to $output_file" "Failed to convert image format."
    log_action "Converted image format from $input_file to $output_file"
}

function resize_image() {
    display_message "Enter the input image file:" "請輸入輸入影像文件：" "Ingrese el archivo de imagen de entrada:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output image file:" "請輸入輸出影像文件：" "Ingrese el archivo de imagen de salida:"
    read output_file
    display_message "Enter the new width:" "請輸入新寬度：" "Ingrese el nuevo ancho:"
    read width
    display_message "Enter the new height:" "請輸入新高度：" "Ingrese el nuevo alto:"
    read height
    command="python3 image_processor.py resize \"$input_file\" \"$output_file\" \"$width\" \"$height\""
    execute_command "$command" "Resized image $input_file to ${width}x${height} and saved as $output_file" "Failed to resize image."
    log_action "Resized image $input_file to ${width}x${height} and saved as $output_file"
}

function rotate_image() {
    display_message "Enter the input image file:" "請輸入輸入影像文件：" "Ingrese el archivo de imagen de entrada:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output image file:" "請輸入輸出影像文件：" "Ingrese el archivo de imagen de salida:"
    read output_file
    display_message "Enter the rotation angle (e.g., 90, 180):" "請輸入旋轉角度 (如 90, 180)：" "Ingrese el ángulo de rotación (por ejemplo, 90, 180):"
    read angle
    command="python3 image_processor.py rotate \"$input_file\" \"$output_file\" \"$angle\""
    execute_command "$command" "Rotated image $input_file by $angle degrees and saved as $output_file" "Failed to rotate image."
    log_action "Rotated image $input_file by $angle degrees and saved as $output_file"
}

function crop_image() {
    display_message "Enter the input image file:" "請輸入輸入影像文件：" "Ingrese el archivo de imagen de entrada:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output image file:" "請輸入輸出影像文件：" "Ingrese el archivo de imagen de salida:"
    read output_file
    display_message "Enter the width of the crop area:" "請輸入裁剪區域的寬度：" "Ingrese el ancho del área de recorte:"
    read width
    display_message "Enter the height of the crop area:" "請輸入裁剪區域的高度：" "Ingrese el alto del área de recorte:"
    read height
    display_message "Enter the x offset of the crop area:" "請輸入裁剪區域的 x 偏移量：" "Ingrese el desplazamiento x del área de recorte:"
    read x_offset
    display_message "Enter the y offset of the crop area:" "請輸入裁剪區域的 y 偏移量：" "Ingrese el desplazamiento y del área de recorte:"
    read y_offset
    command="python3 image_processor.py crop \"$input_file\" \"$output_file\" \"$width\" \"$height\" \"$x_offset\" \"$y_offset\""
    execute_command "$command" "Cropped image $input_file to ${width}x${height}+${x_offset}+${y_offset} and saved as $output_file" "Failed to crop image."
    log_action "Cropped image $input_file to ${width}x${height}+${x_offset}+${y_offset} and saved as $output_file"
}

function merge_images() {
    display_message "Enter the first image file:" "請輸入第一個影像文件：" "Ingrese el primer archivo de imagen:"
    read input_file1
    validate_file_path "$input_file1" || return
    display_message "Enter the second image file:" "請輸入第二個影像文件：" "Ingrese el segundo archivo de imagen:"
    read input_file2
    validate_file_path "$input_file2" || return
    display_message "Enter the output image file:" "請輸入輸出影像文件：" "Ingrese el archivo de imagen de salida:"
    read output_file
    command="python3 image_processor.py merge \"$input_file1\" \"$input_file2\" \"$output_file\""
    execute_command "$command" "Merged images $input_file1 and $input_file2 into $output_file" "Failed to merge images."
    log_action "Merged images $input_file1 and $input_file2 into $output_file"
}

function batch_process_images() {
    display_message "Enter the directory containing images:" "請輸入影像所在目錄：" "Ingrese el directorio que contiene las imágenes:"
    read input_dir
    vaildate_directory "$input_dir" || return
    display_message "Enter the output directory for resized images:" "請輸入輸出目錄：" "Ingrese el directorio de salida:"
    read output_dir
    mkdir -p "$output_dir"

    # Process images in the input directory (Resize, Apply filters, etc.)
    display_message "Select an operation to perform on the images:" "選擇要對影像執行的操作：" "Seleccione una operación para realizar en las imágenes:"
    display_message "1) Batch Resize" "1) 批量調整大小" "1) Cambio de tamaño por lotes"
    display_message "2) Batch Apply Filter" "2) 批量應用濾鏡" "2) Aplicar filtro por lotes"
    read operation_choice
    case $operation_choice in
        1)
            batch_resize_images "$input_dir" "$output_dir"
            ;;
        2)
            batch_apply_filters "$input_dir" "$output_dir"
            ;;
        *)
            clear
            display_message "Invalid choice. Returning to main menu." "無效的選擇。返回主菜單。" "Opción inválida. Volviendo al menú principal."
            ;;
    esac

    log_action "Batch processed images in $input_dir and saved in $output_dir"
}

function batch_resize_images() {
    local input_dir="$1"
    local output_dir="$2"
    display_message "Enter the new width:" "請輸入新寬度：" "Ingrese el nuevo ancho:"
    read width
    display_message "Enter the new height:" "請輸入新高度：" "Ingrese el nuevo alto:"
    read height
    command="python3 image_processor.py batch_resize \"$input_dir\" \"$output_dir\" \"$width\" \"$height\""
    execute_command "$command" "Batch resized images in $input_dir to ${width}x${height} and saved in $output_dir" "Failed to batch resize images."
    log_action "Batch resized images in $input_dir to ${width}x${height} and saved in $output_dir"
}

function batch_apply_filters(){
    local input_dir="$1"
    local output_dir="$2"
    display_message "Select a filter to apply:" "選擇要應用的濾鏡：" "Seleccione un filtro para aplicar:"
    display_message "1) Grayscale" "1) 灰階" "1) Escala de grises"
    display_message "2) Invert" "2) 反轉" "2) Invertir"
    display_message "3) Blur" "3) 模糊" "3) Desenfocar"
    display_message "4) Edge Enhance" "4) 邊緣增強" "4) Mejora de bordes"
    display_message "5) Emboss" "5) 浮雕" "5) Relieve"
    display_message "6) Smooth" "6) 平滑" "6) Suave"
    display_message "7) Sharpen" "7) 銳化" "7) Afilado"
    read filter_choice
    command="python3 image_processor.py batch_apply_filter \"$input_dir\" \"$output_dir\" \"$filter_choice\""
    execute_command "$command" "Batch applied filter to images in $input_dir, saved in $output_dir" "Failed to batch apply filter to images."
    log_action "Batch applied filter to images in $input_dir, saved in $output_dir"
}

function check_file() {
    display_message "Enter the file path to process:" "請輸入要檢查的文件路徑：" "Ingrese la ruta del archivo a procesar:"
    read file_path
    command="python3 image_processor.py check_file \"$file_path\""
    execute_command "$command" "Processed file $file_path for type detection" "Failed to process file $file_path."
    log_action "Processed file $file_path for type detection"
}

function options() {
    while true; do
        clear
        if [ "$LANGUAGE" == "EN" ]; then
            echo "============================="
            echo " Options"
            echo "============================="
            echo "1) Change Language"
            echo "2) Change Terminal Colors"
            echo "3) Resize Terminal"
            echo "4) Show Current Settings"
            echo "5) Back to Main Menu"
        elif [ "$LANGUAGE" == "ZH" ]; then
            echo "============================="
            echo " 選項"
            echo "============================="
            echo "1) 更改語言"
            echo "2) 更改終端機顏色"
            echo "3) 調整終端機大小"
            echo "4) 顯示當前設置"
            echo "5) 返回主菜單"
        elif [ "$LANGUAGE" == "ES" ]; then
            echo "============================="
            echo " Opciones"
            echo "============================="
            echo "1) Cambiar idioma"
            echo "2) Cambiar colores del terminal"
            echo "3) Cambiar tamaño del terminal"
            echo "4) Mostrar configuraciones actuales"
            echo "5) Volver al menú principal"
        fi
        
        read -p "Select an option: " opt_choice
        case $opt_choice in
            1)
                set_language
                ;;
            2)
                change_terminal_colors
                ;;
            3)
                resize_terminal
                ;;
            4)
                show_current_settings
                ;;
            5)
                clear
                return
                ;;
            *)
                display_message "Invalid choice. Please try again." "無效的選擇。請再試一次。" "Opción inválida. Por favor intente de nuevo."
                ;;
        esac
    done
}


function help() {
    display_message "Enter the function ID you need help with:" "請輸入您需要幫助的功能ID：" "Ingrese el ID de la función con la que necesita ayuda:"
    read function_id
    case $function_id in
        1)
            display_message "Convert image format: Converts an image from one format to another." "轉換圖像格式：將圖像從一種格式轉換為另一種格式。" "Convertir formato de imagen: Convierte una imagen de un formato a otro."
            ;;
        2)
            display_message "Resize image: Changes the dimensions of an image." "調整圖像大小：更改圖像的尺寸。" "Cambiar tamaño de imagen: Cambia las dimensiones de una imagen."
            ;;
        3)
            display_message "Rotate image: Rotates an image by a specified angle." "旋轉圖像：按指定角度旋轉圖像。" "Rotar imagen: Rota una imagen por un ángulo especificado."
            ;;
        4)
            display_message "Crop image: Crops a specified area from an image." "裁剪圖像：從圖像中裁剪指定區域。" "Recortar imagen: Recorta un área especificada de una imagen."
            ;;
        5)
            display_message "Merge images: Merges two images into one." "合併圖像：將兩張圖像合併為一張。" "Fusionar imágenes: Fusiona dos imágenes en una."
            ;;
        6)
            display_message "Split GIF/MP4 into frames: Splits a GIF or MP4 file into individual frames." "拆分 GIF/MP4 成幀：將 GIF 或 MP4 文件拆分為單獨的幀。" "Dividir GIF/MP4 en cuadros: Divide un archivo GIF o MP4 en cuadros individuales."
            ;;
        7)
            display_message "Create animation (MP4/GIF): Creates an animation from a series of frames." "創建動畫 (MP4/GIF)：從一系列幀創建動畫。" "Crear animación (MP4/GIF): Crea una animación a partir de una serie de cuadros."
            ;;
        8)
            display_message "Preview animation: Previews an animation from a series of frames." "預覽動畫：從一系列幀預覽動畫。" "Previsualizar animación: Previsualiza una animación a partir de una serie de cuadros."
            ;;
        9)
            display_message "Batch process images: Processes multiple images in a batch." "批量處理圖像：批量處理多個圖像。" "Procesar imágenes por lotes: Procesa múltiples imágenes en un lote."
            ;;
        10)
            display_message "Process file automatically: Automatically processes a file based on its type." "自動處理文件：根據文件類型自動處理文件。" "Procesar archivo automáticamente: Procesa un archivo automáticamente según su tipo."
            ;;
        11)
            display_message "Options: Configures various settings for the tool." "選項：配置工具的各種設置。" "Opciones: Configura varias configuraciones para la herramienta."
            ;;
        12)
            display_message "View Log: Displays the contents of the log file." "查看日誌：顯示日誌文件的內容。" "Ver registro: Muestra el contenido del archivo de registro."
            ;;
        13)
            display_message "Clear Log: Clears the contents of the log file." "清除日誌：清除日誌文件的內容。" "Borrar registro: Borra el contenido del archivo de registro."
            ;;
        14)
            display_message "Help: Provides information about the functions of the tool." "幫助：提供有關工具功能的信息。" "Ayuda: Proporciona información sobre las funciones de la herramienta."
            ;;
        15)
            display_message "Save and Exit: Saves the current settings and exits the tool." "保存並退出：保存當前設置並退出工具。" "Guardar y salir: Guarda la configuración actual y sale de la herramienta."
            ;;
        *)
            display_message "Invalid function ID. Please try again." "無效的功能ID。請再試一次。" "ID de función inválido. Por favor intente de nuevo."
            ;;
    esac

    display_message "Do you want to continue? (y/n):" "是否繼續？(y/n)：" "¿Quieres continuar? (s/n):"
    read continue
    if [ "$continue" != "y" ]; then
        display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
        log_action "Program exited."
        exit 0
    fi
    clear
}

function main() {
    clear
    set_language
    clear
    while true; do
        show_menu
        choice=$?
        case $choice in
            1)
                convert_image_format
                ;;
            2)
                resize_image
                ;;
            3)
                rotate_image
                ;;
            4)
                crop_image
                ;;
            5)
                merge_images
                ;;
            6)
                apply_filters
                ;;
            7)
                split_gif_mp4
                ;;
            8)
                split_sprite_sheet
                ;;
            9)
                create_animation
                ;;
            10)
                preview_animation
                ;;
            11)
                batch_process_images
                ;;
            12)
                check_file
                ;;
            13)
                options
                ;;
            14)
                view_log
                ;;
            15)
                clear_log
                ;;
            16)
                help
                ;;
            17)
                display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
                log_action "Program exited."
                exit 0
                ;;
            *)
                display_message "Invalid choice. Please try again." "無效的選擇。請再試一次。" "Opción inválida. Por favor intente de nuevo."
                ;;
        esac
    done
}

main