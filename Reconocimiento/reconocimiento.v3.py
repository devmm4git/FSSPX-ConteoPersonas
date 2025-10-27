import subprocess
import sys

# -----------------------------
# Instala paquetes si no existen
# -----------------------------
def install_if_missing(packages):
    import importlib
    for package in packages:
        try:
            importlib.import_module(package)
        except ImportError:
            print(f"📦 Instalando {package}...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", package])

required_packages = ["opencv-python", "numpy", "ultralytics"]
install_if_missing(required_packages)

# -----------------------------
# Imports
# -----------------------------
import cv2
import numpy as np
from ultralytics import YOLO

# -----------------------------
# Configuración
# -----------------------------
model = YOLO("yolov8s.pt")  # usa yolov8n.pt si tu CPU es débil
video_path = "P5_20251026_095349.mp4"
cap = cv2.VideoCapture(video_path)

frame_skip = 2          # Procesar 1 de cada 2 frames (ajusta según velocidad)
min_confidence = 0.45   # Confianza mínima para considerar detección válida
object_ids = set()      # IDs únicos de personas detectadas
frame_count = 0

# -----------------------------
# Procesamiento de video
# -----------------------------
while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_count += 1
    # Solo procesamos cada "frame_skip" frames
    if frame_count % frame_skip != 0:
        continue

    # Detección + tracking de personas
    results = model.track(frame, persist=True, classes=[0], conf=min_confidence)

    # Si hay detecciones válidas
    if len(results) > 0 and getattr(results[0].boxes, "id", None) is not None:
        ids = results[0].boxes.id.cpu().numpy().astype(int)
        for id_ in ids:
            object_ids.add(id_)

        # Dibuja detecciones
        annotated_frame = results[0].plot()

    else:
        annotated_frame = frame

    # Mostrar conteo en pantalla
    cv2.putText(annotated_frame, f"Personas únicas detectadas: {len(object_ids)}",
                (30, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    cv2.imshow("Conteo de Personas (Cuerpo Completo)", annotated_frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()

print(f"\n✅ Total estimado de personas únicas: {len(object_ids)}")
