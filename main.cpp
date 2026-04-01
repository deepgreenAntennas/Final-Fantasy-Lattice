#include <SDL.h>
#include <iostream>

#ifdef _OPENMP
    #include <omp.h>
#endif

int main(int argc, char *argv[]) {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        std::cerr << "SDL could not initialize! SDL_Error: " << SDL_GetError() << std::endl;
        return 1;
    }

    // iPhone 13 Resolution handles better with 0,0 (Fullscreen)
    SDL_Window* window = SDL_CreateWindow("Final Fantasy Lattice",
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
        0, 0, SDL_WINDOW_FULLSCREEN | SDL_WINDOW_ALLOW_HIGHDPI);

    if (!window) {
        std::cerr << "Window could not be created! SDL_Error: " << SDL_GetError() << std::endl;
        return 1;
    }

    SDL_Delay(3000); // Show a black screen for 3 seconds
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
