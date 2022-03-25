#!/usr/bin/env python

from __future__ import annotations
import requests
import os
import sys
import time

# class FileUpload:
#     pass

class FileDonwload:
    def __init__(self, url_path: str) -> None:
        self.url_path: str = url_path
    def download(self) -> None:
        with requests.get(self.url_path, stream=True) as r:
            download_path: str = self.url_path.split('//')
            try:
                with open(download_path[1], 'wb') as file:
                    file.write(r.content)
                    toolbar_len = 50
                    sys.stdout.write("\033[1;32m[%s]\033[0m" % (" " * toolbar_len))
                    sys.stdout.flush()
                    sys.stdout.write('\b' * (toolbar_len + 1))


                    for i in range(toolbar_len):
                        sys.stdout.write("\033[1;32m=\033[0m")
                        time.sleep(0.1)
                        sys.stdout.write('\033[1;32m>\033[0m')
                        sys.stdout.flush()
                        sys.stdout.write('\b')
                    sys.stdout.write("\033[1;32m]\033[0m\n")
            except FileNotFoundError:
                print(f'{download_path[1]}: not found')

if __name__ == '__main__':
    urlpath = sys.argv[1]
    f = FileDonwload(urlpath)
    f.download()