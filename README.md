# Sis2project
## Como iniciar a trabajar en el repo

1. Clonar el repositorio 
```
git clone https://github.com/SisInfo2/Sis2project
```
2. Ingresar a la carpeta generada
```
cd Sis2Project
```
3. En el netbeans darle a abrir proyecto que se acaba de generar

4. Crear una rama para trabajar
```
git checkout -b [nombre de la rama]
```
5. Empezar a trabajar

## Como trabajar despues de haber clonado el repo

1. Traer los cambios que se hallan realizado en el repositorio 
```
git pull
```
2. Asegurarse de estar en la rama que deseo trabajar y no en la rama main
```
git branch
```
3. En caso de estar en la rama main o en una rama que no corresponde, cambiar de rama
```
git checkout [nombre de la rama]
```

4. Empezar a realizar las tareas correspondientes ej. Interfaz lista de materias

5. una vez hecha alguna funcionalidad escribir la siguiente secuencia de instrucciones
```
git add .
git commit -m "[mensaje descriptivo]"
git push origin [nombre de la rama]
```


