import subprocess
import sys

# -----------------------------
# Función para instalar paquetes si no existen
# -----------------------------
def install_if_missing(packages):
    import importlib
    for package in packages:
        try:
            importlib.import_module(package)
        except ImportError:
            print(f"📦 Instalando {package}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# Lista de paquetes necesarios
required_packages = ["opencv-python", "numpy", "ultralytics"]
install_if_missing(required_packages)

# -----------------------------
# Ahora importamos los paquetes ya seguros
# -----------------------------
import cv2
import numpy as np
from ultralytics import YOLO

# -----------------------------
# Configuración del modelo y video
# -----------------------------
model = YOLO("yolov8n.pt")  # Puedes usar 'yolov8s.pt' si tienes GPU
video_path = "P2_20251026_093942.mp4"
cap = cv2.VideoCapture(video_path)

# -----------------------------
# Inicializa el tracker
# -----------------------------
from collections import defaultdict
object_ids = set()  # IDs únicos de personas detectadas
frame_count = 0

# -----------------------------
# Procesamiento del video
# -----------------------------
while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_count += 1
    results = model.track(frame, persist=True, classes=[0])  # class 0 = 'person'

    if results[0].boxes.id is not None:
        ids = results[0].boxes.id.cpu().numpy().astype(int)
        for id_ in ids:
            object_ids.add(id_)

    # Dibuja detecciones (opcional)
    annotated_frame = results[0].plot()
    cv2.putText(annotated_frame, f"Personas únicas: {len(object_ids)}", (30, 50),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    cv2.imshow("Conteo de Personas", annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()

print(f"\n✅ Total estimado de personas únicas: {len(object_ids)}")
