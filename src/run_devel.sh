# Run update
sudo docker run -it \
     -v /home/nitesh_turaga_gmail_com/shared-devel:/usr/local/lib/R/host-site-library \
     bioconductor/bioconductor_full:devel R -f update_packages.R

# Run rsync
gsutil -m rsync -d -r shared-devel/ gs://bioconductor-full-devel
