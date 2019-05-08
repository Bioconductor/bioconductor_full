# Run update
sudo docker run -it \
     -v /home/nitesh_turaga_gmail_com/shared-release-3-8:/usr/local/lib/R/host-site-library \
     -v /home/nitesh_turaga_gmail_com/bioconductor_full/src/update_packages.R:/tmp/update_packages.R \
     bioconductor/bioconductor_full:RELEASE_3_8 \
     R -f /tmp/update_packages.R

# Run rsync
gsutil -m rsync -d -r /home/nitesh_turaga_gmail_com/shared-release-3-8/ gs://bioconductor-full-release-3-8
