ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

DATADIR?=themes/

#append -DWITH_WIIUSE to compile with WIIUSE support!
#append -DNOSOUND to compile WITHOUT sound support
CC=g++ -DDATADIR="\"$(DATADIR)\""

ifeq ($(detected_OS),Darwin) # macOS
  CFLAGS+=-c -Wall `sdl-config --cflags` -Wno-deprecated-declarations 
else
  CFLAGS+=-c -Wall `sdl-config --cflags`
endif


#append -lwiiuse to compile with WIIUSE support
#remove -lSDL_mixer if compiling with -DNOSOUND
ifeq ($(detected_OS),Darwin) # macOS
  LIBS+=-framework OpenGL `sdl-config --libs` -lSDL_image -lSDL_ttf -lSDL_mixer
else
  LIBS+=-lGL -lGLU `sdl-config --libs` -lSDL_image -lSDL_ttf -lSDL_mixer
endif

SOURCES=main.cpp 
OBJECTS=$(SOURCES:.cpp=.o)

EXECUTABLE=sdl-ball

all: $(SOURCES) $(EXECUTABLE)
	
$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o $@

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f *.o sdl-ball

remove:
	rm -R ~/.config/sdl-ball
	
