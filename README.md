# tracking_app

Tracking app permite obtener la ubicación de un dispositivo mediante un botón, algunas de sus funcionalidades son:

- Obtener la ubicación del dispositivo.
- Almacenar las ubicaciones y mostrarlas en una lista. 
- Obtener el codigo postal de cada ubicación guardada.

### Uso de herramientas
Algunas de las tecnologías utilizadas para el desarrollo de esta app son:

- [permission_handler] - Solicitar permisos para utilizar la ubicación del dispositivo.    
- [geolocator] - Obtener la ubicación del dispositivo.    
- [shared_preferences] - Persistencia de datos.    
- [dio] - Gestión de peticiones a la API.

## Para empezar

### Guía de instalación para el proyecto
  
El primer paso es clonar el repositorio del proyecto, esto lo hacemos con el siguiente comando:  

- git clone [https://github.com/IsaiGonzalez08/tracking_app.git](https://github.com/IsaiGonzalez08/tracking_app.git)


El siguiente paso es realizar la instalación de las dependencias de flutter necesarias para que el proyecto pueda funcionar, para esto tenemos que ejecutar el siguiente comando:  

- flutter pub get  

Una vez termine la instalación las dependencias podremos ejecutar el proyecto, para esto podemos utilizar el siguiente comando:  

- flutter run

## Uso de proyecto

Como primer vista tenemos al botón que nos permite obtener la ubicación del disposito, que se ve de la siguiente manera:

<img src="https://github.com/user-attachments/assets/669a03fc-25f1-445c-b721-93dda196d273" alt="init" width="200"/>

Si el usuario presiona el botón LOCATION NOW la app obtendra la ubicación del dispositivo:

<img src="https://github.com/user-attachments/assets/8e493b5e-c34d-4a2d-9bd9-0ee11a58f620" alt="init" width="200"/>

La lista de ubicaciones que se hayan obtenido se mostraran en una lista en otra vista:

<img src="https://github.com/user-attachments/assets/4aa7ce9d-1c5d-4862-95db-d296897e8960" alt="init" width="200"/>

