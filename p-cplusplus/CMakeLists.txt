cmake_minimum_required(VERSION 3.0)
project(cplusplus-microservice)
add_executable(${PROJECT_NAME} src/main.cpp)
find_package(cpprestsdk REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE cpprestsdk::cpprest)
