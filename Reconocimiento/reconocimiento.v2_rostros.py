import subprocess
import sys

# -----------------------------
# Instalar paquetes si faltan
# -----------------------------
def install_if_missing(packages):
    import importlib
    for package in packages:
        try:
            importlib.import_module(package)
        except ImportError:
            print(f"📦 Instalando {package}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])

install_if_missing(["ultralytics", "opencv-python", "numpy"])

# -----------------------------
# Importar librerías
# -----------------------------
import cv2
from ultralytics import YOLO
import numpy as np

# -----------------------------
# Cargar el modelo YOLOv8 para rostros
# -----------------------------
# Nota: Puedes descargar un modelo preentrenado para faces
# Si no tienes uno, puedes usar 'yolov8n.pt' y filtrar por la clase 'face' si está disponible
model = YOLO("yolov8n.pt")  # Cambiar por 'yolov8n-face.pt' si lo tienes

# -----------------------------
# Cargar video
# -----------------------------
video_path = "P1_20251026_093751_rotado.mp4"
cap = cv2.VideoCapture(video_path)

# -----------------------------
# Seguimiento de rostros únicos
# -----------------------------
unique_ids = set()  # IDs únicos de rostros detectados

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # Reducir resolución para velocidad (opcional)
    frame_small = cv2.resize(frame, (640, 360))

    # Detectar y trackear rostros (track=True)
    results = model.track(frame_small, persist=True, classes=[0])  # class 0 = person, si hay face model cambia a face

    # Agregar IDs únicos
    if results[0].boxes.id is not None:
        ids = results[0].boxes.id.cpu().numpy().astype(int)
        for id_ in ids:
            unique_ids.add(id_)

    # Dibujar cajas y conteo
    annotated_frame = results[0].plot()
    cv2.putText(annotated_frame, f"FSSPX Personas : {len(unique_ids)}", (30,50),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0,255,0), 2)

    cv2.imshow("Conteo de Rostros Unicos", annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()

print(f"\n✅ Total estimado de personas únicas: {len(unique_ids)}")
