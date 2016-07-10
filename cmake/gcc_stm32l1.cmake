SET(CMAKE_C_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m3 -Wall -std=gnu99 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m3 -Wall -std=c++11 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_ASM_FLAGS "-mthumb -mcpu=cortex-m3 -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")

SET(CMAKE_EXE_LINKER_FLAGS "--verbose -Wl,--gc-sections -mthumb -mcpu=cortex-m3 -mabi=aapcs" CACHE INTERNAL "executable linker flags")
SET(CMAKE_MODULE_LINKER_FLAGS "-mthumb -mcpu=cortex-m3 -mabi=aapcs" CACHE INTERNAL "module linker flags")
SET(CMAKE_SHARED_LINKER_FLAGS "-mthumb -mcpu=cortex-m3 -mabi=aapcs" CACHE INTERNAL "shared linker flags")

SET(STM32_CHIP_TYPES 100xB   100xBA   100xC   151xB   151xBA   151xC   151xCA   151xD   151xDX   151xE   152xB   152xBA   152xC   152xCA   152xD   152xDX   152xE   162xC   162xCA   162xD   162xDX   162xE   CACHE INTERNAL "stm32l1 chip types")
SET(STM32_CODES     "100.B" "100.BA" "100.C" "151.B" "151.BA" "151.C" "151.CA" "151.D" "151.DX" "151.E" "152.B" "152.BA" "152.C" "152.CA" "152.D" "152.DX" "152.E" "162.C" "162.CA" "162.D" "162.DX" "162.E")

MACRO(STM32_GET_CHIP_TYPE CHIP CHIP_TYPE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[lL]((100.[BC])|(100.[BC]A)|(15[12].[BCE])|(15[12].[BC]A)|(15[12].DX)|(162.[EDC])|(162.CA)|(162.DX)).+$" "\\1" STM32_CODE ${CHIP})
    SET(INDEX 0)
    FOREACH(C_TYPE ${STM32_CHIP_TYPES})
        LIST(GET STM32_CODES ${INDEX} CHIP_TYPE_REGEXP)
        IF(STM32_CODE MATCHES ${CHIP_TYPE_REGEXP})
            SET(RESULT_TYPE ${C_TYPE})
        ENDIF()
        MATH(EXPR INDEX "${INDEX}+1")
    ENDFOREACH()
    SET(${CHIP_TYPE} ${RESULT_TYPE})
ENDMACRO()

MACRO(STM32_GET_CHIP_PARAMETERS CHIP FLASH_SIZE RAM_SIZE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[lL](1[056][012]).([68BCDE]$|[68BCDE][AX]$)" "\\1" STM32_CODE ${CHIP})
    STRING(REGEX REPLACE "^[sS][tT][mM]32[lL](1[056][012]).([68BCDE]$|[68BCDE][AX]$)" "\\2" STM32_SIZE_CODE ${CHIP})

    IF(STM32_SIZE_CODE STREQUAL "6" OR STM32_SIZE_CODE STREQUAL "6A")
        SET(FLASH "32K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "8" OR STM32_SIZE_CODE STREQUAL "8A")
        SET(FLASH "64K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "B" OR STM32_SIZE_CODE STREQUAL "BA")
        SET(FLASH "128K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "C" OR STM32_SIZE_CODE STREQUAL "CA")
        SET(FLASH "256K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "D" OR STM32_SIZE_CODE STREQUAL "DX")
        SET(FLASH "384K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "E")
        SET(FLASH "512K")
    ENDIF()

    STM32_GET_CHIP_TYPE(${CHIP} TYPE)
    
    IF(${TYPE} STREQUAL 100xB)
        SET(RAM "10K")
        SET(FLASH "128K")
    ELSEIF(${TYPE} STREQUAL 100xBA)
        SET(RAM "16K")
        SET(FLASH "128K")
    ELSEIF(${TYPE} STREQUAL 100xC)
        SET(RAM "16K")
        SET(FLASH "256K")

    ELSEIF(${TYPE} STREQUAL 151xB)
        SET(RAM "16K")
        SET(FLASH "128K")
    ELSEIF(${TYPE} STREQUAL 151xBA)
        SET(RAM "32K")
        SET(FLASH "128K")
    ELSEIF(${TYPE} STREQUAL 151xC)
        SET(RAM "32K")
        SET(FLASH "256K")
    ELSEIF(${TYPE} STREQUAL 151xCA)
        SET(RAM "32K")
        SET(FLASH "256K")
    ELSEIF(${TYPE} STREQUAL 151xD)
        SET(RAM "48K")
        SET(FLASH "384K")
    ELSEIF(${TYPE} STREQUAL 151xDX)
        SET(RAM "80K")
        SET(FLASH "384K")
    ELSEIF(${TYPE} STREQUAL 151xE)
        SET(RAM "80K")
        SET(FLASH "512K")

    ELSEIF(${TYPE} STREQUAL 152xB)
        SET(RAM "16K")
        SET(FLASH "128K")
    ELSEIF(${TYPE} STREQUAL 152xBA)
        SET(RAM "32K")
        SET(FLASH "128K")
    ELSEIF(${TYPE} STREQUAL 152xC)
        SET(RAM "32K")
        SET(FLASH "256K")
    ELSEIF(${TYPE} STREQUAL 152xCA)
        SET(RAM "32K")
        SET(FLASH "256K")
    ELSEIF(${TYPE} STREQUAL 152xD)
        SET(RAM "48K")
        SET(FLASH "384K")
    ELSEIF(${TYPE} STREQUAL 152xDX)
        SET(RAM "80K")
        SET(FLASH "384K")
    ELSEIF(${TYPE} STREQUAL 152xE)
        SET(RAM "80K")
        SET(FLASH "512K")

    ELSEIF(${TYPE} STREQUAL 162xC)
        SET(RAM "32K")
        SET(FLASH "256K")
    ELSEIF(${TYPE} STREQUAL 162xCA)
        SET(RAM "32K")
        SET(FLASH "256K")
    ELSEIF(${TYPE} STREQUAL 162xD)
        SET(RAM "48K")
        SET(FLASH "384K")
    ELSEIF(${TYPE} STREQUAL 162xDX)
        SET(RAM "80K")
        SET(FLASH "384K")
    ELSEIF(${TYPE} STREQUAL 162xE)
        SET(RAM "80K")
        SET(FLASH "512K")
    ENDIF()

    SET(${FLASH_SIZE} ${FLASH})
    SET(${RAM_SIZE} ${RAM})
ENDMACRO()

FUNCTION(STM32_SET_CHIP_DEFINITIONS TARGET CHIP_TYPE)
    LIST(FIND STM32_CHIP_TYPES ${CHIP_TYPE} TYPE_INDEX)
    IF(TYPE_INDEX EQUAL -1)
        MESSAGE(FATAL_ERROR "Invalid/unsupported STM32L1 chip type: ${CHIP_TYPE}")
    ENDIF()
    GET_TARGET_PROPERTY(TARGET_DEFS ${TARGET} COMPILE_DEFINITIONS)
    IF(TARGET_DEFS)
        SET(TARGET_DEFS "STM32L${CHIP_TYPE};${TARGET_DEFS}")
    ELSE()
        SET(TARGET_DEFS "STM32L${CHIP_TYPE}")
    ENDIF()
    SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_DEFINITIONS "${TARGET_DEFS}")
ENDFUNCTION()
