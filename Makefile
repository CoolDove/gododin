dll: clean
	mkdir bin && \
	odin build . -debug -build-mode:shared -out:bin/godlib.windows.debug.x86_64.dll && \
	odin build . -build-mode:shared -out:bin/godlib.windows.release.x86_64.dll

clean:
	rm bin/ -rf

bg:
	pushd bindgen && \
	odin run . -out:g.exe && \
	rm g.exe && \
	popd
