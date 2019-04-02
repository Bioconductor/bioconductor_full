# Run update
sudo docker run -it \
     -v /home/nitesh_turaga_gmail_com/shared-release-3-8:/usr/local/lib/R/host-site-library \
     -v /home/nitesh_turaga_gmail_com/AnVIL_Docker/src/update_packages:/tmp/update_packages.R \
     bioconductor/bioconductor_full:RELEASE_3_8 \
     R -f /tmp/update_packages.R

# Run rsync
gsutil -m rsync -d -r shared-release-3-8/ gs://bioconductor-full-release-3-8
