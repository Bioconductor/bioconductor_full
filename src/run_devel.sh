# Run update
sudo docker run -it \
     -v /home/nitesh_turaga_gmail_com/shared-devel:/usr/local/lib/R/host-site-library \
     -v /home/nitesh_turaga_gmail_com/AnVIL_Docker/src/update_packages.R:/tmp/update_packages.R \
     bioconductor/bioconductor_full:devel \
     R -f /tmp/update_packages.R

# Run rsync
gsutil -m rsync -d -r shared-devel/ gs://bioconductor-full-devel
