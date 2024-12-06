#!/bin/bash

LANGUAGE="EN"
FRAME_RATE=30
BRIGHTNESS=1.0
CONTRAST=1.0

LOG_FILE="program.log"

function log_action() {
    local action_message="$1"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $action_message" >> "$LOG_FILE"
}

function view_log() {
    display_message "Displaying log file contents:" "顯示日誌文件內容：" "Mostrando el contenido del archivo de registro:"
    if [ -f "$LOG_FILE" ]; then
        cat "$LOG_FILE"
    else
        display_message "Log file does not exist. Creating a new log file." "日誌文件不存在。正在創建新日誌文件。" "El archivo de registro no existe. Creando un nuevo archivo de registro."
        touch "$LOG_FILE"
    fi
}

function clear_log() {
    display_message "Clearing log file contents..." "清除日誌文件內容..." "Borrando el contenido del archivo de registro..."
    > "$LOG_FILE"
    display_message "Log file cleared." "日誌文件已清除。" "Archivo de registro borrado."
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
        elif [ "$page" == "2" ]; then
            echo "6-8) Animation Processing:"
            echo "  6) Split GIF/MP4 into frames"
            echo "  7) Create animation (MP4/GIF)"
            echo "  8) Preview animation"
            echo "9-10) Batch and Automatic Processing:"
            echo "  9) Batch process images"
            echo " 10) Process file automatically"
        elif [ "$page" == "3" ]; then
            echo "11-13) System Options:"
            echo " 11) Options"
            echo " 12) View Log"
            echo " 13) Save and Exit"
        fi
        echo "============================="
        echo "Please select an option (or 'n' for next page, 'p' for previous page):"
    elif [ "$LANGUAGE" == "ZH" ]; then
        echo "============================="
        echo " 動態圖像工具"
        echo "============================="
        if [ "$page" == "1" ]; then
            echo "1-5) 圖像處理:"
            echo "  1) 轉換圖像格式"
            echo "  2) 調整圖像大小"
            echo "  3) 旋轉圖像"
            echo "  4) 裁剪圖像"
            echo "  5) 合併圖像"
        elif [ "$page" == "2" ]; then
            echo "6-8) 動畫處理:"
            echo "  6) 拆分 GIF/MP4 成幀"
            echo "  7) 創建動畫 (MP4/GIF)"
            echo "  8) 預覽動畫"
            echo "9-10) 批量和自動處理:"
            echo "  9) 批量處理圖像"
            echo " 10) 自動處理文件"
        elif [ "$page" == "3" ]; then
            echo "11-13) 系統選項:"
            echo " 11) 選項"
            echo " 12) 查看日誌"
            echo " 13) 保存並退出"
        fi
        echo "============================="
        echo "請選擇一個選項（或 'n' 進入下一頁，'p' 返回上一頁）:"
    elif [ "$LANGUAGE" == "ES" ]; then
        echo "============================="
        echo " Herramienta de Imagen Dinámica"
        echo "============================="
        if [ "$page" == "1" ]; then
            echo "1-5) Procesamiento de imágenes:"
            echo "  1) Convertir formato de imagen"
            echo "  2) Cambiar tamaño de imagen"
            echo "  3) Rotar imagen"
            echo "  4) Recortar imagen"
            echo "  5) Fusionar imágenes"
        elif [ "$page" == "2" ]; then
            echo "6-8) Procesamiento de animación:"
            echo "  6) Dividir GIF/MP4 en cuadros"
            echo "  7) Crear animación (MP4/GIF)"
            echo "  8) Previsualizar animación"
            echo "9-10) Procesamiento por lotes y automático:"
            echo "  9) Procesar imágenes por lotes"
            echo " 10) Procesar archivo automáticamente"
        elif [ "$page" == "3" ]; then
            echo "11-13) Opciones del sistema:"
            echo " 11) Opciones"
            echo " 12) Ver registro"
            echo "  13) Guardar y salir"
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
            1|2|3|4|5|6|7|8|9|10|11|12|13)
                return $choice
                ;;
            n)
                if [ $page -lt 3 ]; then
                    page=$((page + 1))
                fi
                ;;
            p)
                if [ $page -gt 1 ]; then
                    page=$((page - 1))
                fi
                ;;
            *)
                display_message "Invalid choice. Please try again." "無效的選擇。請再試一次。" "Opción inválida. Por favor intente de nuevo."
                ;;
        esac
    done
}

function validate_file_path() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        log_action "Error: File not found - $file_path"
        display_message "Error: File not found. Returning to main menu." "錯誤：文件未找到。返回主菜單。" "Error: Archivo no encontrado. Volviendo al menú principal."
        return 1
    fi
    return 0
}

function vaildate_directory() {
    local dir_path="$1"
    if [ ! -d "$dir_path" ]; then
        log_action "Error: Directory not found - $dir_path"
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
        # Ask user if they want to continue, if so return to main menu, else exit
        display_message "Do you want to continue? (y/n):" "是否繼續？(y/n)：" "¿Quieres continuar? (s/n):"
        read continue
        if [ "$continue" != "y" ]; then
            display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
            log_action "Program exited."
            exit 0
        fi
        clear
    else
        display_message "$error_message" "操作失敗！請查看日誌文件。" "¡Operación fallida! Por favor, revise el archivo de registro."
        echo "[$(date)] $error_message" >> "$LOG_FILE"
        display_message "Do you want to continue? (y/n):" "是否繼續？(y/n)：" "¿Quieres continuar? (s/n):"
        read continue
        if [ "$continue" != "y" ]; then
            display_message "Exiting the program. Thank you!" "程序結束，感謝使用！" "Saliendo del programa. ¡Gracias!"
            log_action "Program exited."
            exit 0
        fi
        clear
    fi
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
    command="python3 video_processor.py create_animation \"$frames_dir\" \"$output_file\" \"$FRAME_RATE\""
    execute_command "$command" "Created animation $output_file from frames in $frames_dir" "Failed to create animation $output_file."
    log_action "Created animation $output_file from frames in $frames_dir"
}

#To Be Fixed
function apply_filters() {
    display_message "Enter the path of the image file:" "請輸入影像文件路徑：" "Ingrese la ruta del archivo de imagen:"
    read input_file
    validate_file_path "$input_file" || return
    display_message "Enter the output file path:" "請輸入輸出文件路徑：" "Ingrese la ruta del archivo de salida:"
    read output_file
    command="python3 image_processor.py apply_filters \"$input_file\" \"$output_file\" \"$BRIGHTNESS\" \"$CONTRAST\""
    execute_command "$command" "Applied filters to $input_file and saved as $output_file" "Failed to apply filters to $input_file."
    log_action "Applied filters to $input_file and saved as $output_file"
}

function preview_animation() {
    display_message "Enter the file name of the animation to preview:" "請輸入要預覽的動畫文件名：" "Ingrese el nombre del archivo de animación para previsualizar:"
    read preview_file
    validate_file_path "$preview_file" || return
    xdg-open "$preview_file"
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

function batch_resize_images() {
    display_message "Enter the directory containing images:" "請輸入影像所在目錄：" "Ingrese el directorio que contiene las imágenes:"
    read input_dir
    vaildate_directory "$input_dir" || return
    display_message "Enter the output directory for resized images:" "請輸入輸出目錄：" "Ingrese el directorio de salida:"
    read output_dir
    mkdir -p "$output_dir"
    display_message "Enter the new width:" "請輸入新寬度：" "Ingrese el nuevo ancho:"
    read width
    display_message "Enter the new height:" "請輸入新高度：" "Ingrese el nuevo alto:"
    read height
    command="python3 image_processor.py batch_resize \"$input_dir\" \"$output_dir\" \"$width\" \"$height\""
    execute_command "$command" "Batch resized images in $input_dir to ${width}x${height}, saved in $output_dir" "Failed to batch resize images."
    log_action "Batch resized images in $input_dir to ${width}x${height}, saved in $output_dir"
}

function check_file() {
    display_message "Enter the file path to process:" "請輸入要處理的文件路徑：" "Ingrese la ruta del archivo a procesar:"
    read file_path
    command="python3 file_processor.py check_file \"$file_path\""
    execute_command "$command" "Processed file $file_path for type detection" "Failed to process file $file_path."
    log_action "Processed file $file_path for type detection"
}

function options() {
    if [ "$LANGUAGE" == "EN" ]; then
        echo "============================="
        echo " Options"
        echo "============================="
        echo "1) Change Language"
        echo "2) Set Frame Rate"
        echo "3) Set Brightness"
        echo "4) Set Contrast"
        echo "5) Back to Main Menu"
    elif [ "$LANGUAGE" == "ZH" ]; then
        echo "============================="
        echo " 選項"
        echo "============================="
        echo "1) 更改語言"
        echo "2) 設定幀率"
        echo "3) 設定亮度"
        echo "4) 設定對比度"
        echo "5) 返回主菜單"
    elif [ "$LANGUAGE" == "ES" ]; then
        echo "============================="
        echo " Opciones"
        echo "============================="
        echo "1) Cambiar idioma"
        echo "2) Establecer tasa de cuadros"
        echo "3) Establecer brillo"
        echo "4) Establecer contraste"
        echo "5) Volver al menú principal"
    fi
    read opt_choice
    case $opt_choice in
        1)
            set_language
            ;;
        2)
            display_message "Enter the frame rate:" "請輸入幀率：" "Ingrese la tasa de cuadros:"
            read FRAME_RATE
            ;;
        3)
            display_message "Enter the brightness adjustment value (default 1.0):" "請輸入亮度調整值 (默認 1.0)：" "Ingrese el valor de ajuste de brillo (predeterminado 1.0):"
            read BRIGHTNESS
            ;;
        4)
            display_message "Enter the contrast adjustment value (default 1.0):" "請輸入對比度調整值 (默認 1.0)：" "Ingrese el valor de ajuste de contraste (predeterminado 1.0):"
            read CONTRAST
            ;;
        5)
            return
            ;;
        *)
            display_message "Invalid choice. Returning to main menu." "無效的選擇。返回主菜單。" "Opción inválida. Volviendo al menú principal."
            ;;
    esac
}

function main() {
    set_language
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
                split_gif_mp4
                ;;
            7)
                create_animation
                ;;
            8)
                preview_animation
                ;;
            9)
                batch_resize_images
                ;;
            10)
                check_file
                ;;
            11)
                options
                ;;
            12)
                view_log
                ;;
            13)
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