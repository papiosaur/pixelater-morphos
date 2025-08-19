# Makefile pour pixelater (MorphOS)
PROJECT_NAME = pixelater
TARGET = $(PROJECT_NAME)

# Compilateur et flags
CXX = ppc-morphos-g++-11
CXXFLAGS = -noixemul -O2 -Wall -fsigned-char
LDFLAGS = -noixemul

# Répertoires d'inclusion
INCLUDES = -Iraylib/src \
           -IrlImGui \
           -Iimgui \
           -Istb \
           -I/gg/usr/local/include \
           -I/gg/usr/local/include/SDL2

# Flags de compilation supplémentaires
CXXFLAGS += $(INCLUDES) -pthread -fpermissive -fsigned-char -D__AMIGADATE__=\"17.8.2025\"

# Bibliothèques à lier
LIBDIRS = -L/gg/usr/local/lib
LIBS = -lraylib -lSDL2 -lSDL2_mixer -lSDL2_image -lSDL2_ttf -lGL -lstdc++ -pthread -lc -lm

# Fichiers sources
IMGUI_SOURCES = imgui/imgui.cpp \
                imgui/imgui_demo.cpp \
                imgui/imgui_draw.cpp \
                imgui/imgui_tables.cpp \
                imgui/imgui_widgets.cpp \
                imgui/backends/imgui_impl_sdl2.cpp \
                imgui/backends/imgui_impl_opengl2.cpp \
                imgui/backends/imgui_impl_sdlrenderer2.cpp

RLIMGUI_SOURCES = rlImGui/rlImGui.cpp

MAIN_SOURCES = main.cpp \
               gui.cpp \
               pixel-draw.cpp

# Tous les fichiers sources
SOURCES = $(MAIN_SOURCES) $(IMGUI_SOURCES) $(RLIMGUI_SOURCES)

# Fichiers objets
OBJECTS = $(SOURCES:.cpp=.o)

# Règle par défaut
all: copy_fonts $(TARGET)

# Compilation du programme principal
$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) $(LIBDIRS) $(LIBS) -o $@

# Règle générale pour compiler les fichiers .cpp en .o
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Copie des polices (équivalent du copy_assets dans CMake)
copy_fonts:
	@mkdir -p fonts
	@if [ -d "fonts" ]; then \
		echo "Fonts directory already exists"; \
	fi

# Nettoyage
clean:
	rm -f $(OBJECTS) $(TARGET)

# Nettoyage complet
distclean: clean
	rm -rf fonts

# Installation (optionnel)
install: $(TARGET)
	@echo "Installation not implemented yet"

# Règles qui ne correspondent pas à des fichiers
.PHONY: all clean distclean install copy_fonts

# Dépendances (optionnel - pour une compilation plus intelligente)
-include $(OBJECTS:.o=.d)

# Génération automatique des dépendances
%.d: %.cpp
	@$(CXX) $(CXXFLAGS) -MM $< > $@