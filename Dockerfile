# ใช้ Image พื้นฐานของ Jupyter ที่มี Conda ติดตั้งมาให้
FROM jupyter/base-notebook:latest

# คัดลอกไฟล์ spec-file.txt เข้าไปใน Image
COPY spec-file.txt /tmp/

# สร้าง Conda environment จากไฟล์ spec-file และลบไฟล์ที่ไม่จำเป็นออกเพื่อลดขนาด Image
RUN conda env create -f /tmp/spec-file.txt --name ml && \
    conda clean -afy

# ติดตั้ง ipykernel ใน environment 'ml' เพื่อให้ Jupyter มองเห็น
RUN conda run -n ml pip install --no-cache-dir ipykernel && \
    conda run -n ml python -m ipykernel install --user --name=ml --display-name="Python (ml)"

# คัดลอกไฟล์ทั้งหมดในโปรเจกต์เข้าไปใน work directory ของ Jupyter
COPY . /home/jovyan/work

# ตั้งค่าเจ้าของไฟล์ให้เป็น user ของ Jupyter
RUN chown -R ${NB_UID}:${NB_GID} /home/jovyan/work
