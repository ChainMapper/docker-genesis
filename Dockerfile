FROM chainmapper/walletbase-bionic-build as builder

ENV GIT_COIN_URL    https://github.com/genesisofficial/genesis.git
ENV GIT_COIN_NAME   genesis   

RUN wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz \
    && tar -zxvf libsodium-1.0.16.tar.gz \
    && cd libsodium-1.0.16 \
    && ./configure \
    && make && make check \
    && make install

RUN	git clone $GIT_COIN_URL $GIT_COIN_NAME \
	&& cd $GIT_COIN_NAME \
	#&& git checkout tags/v3.0.0 \
	&& chmod +x autogen.sh \
	&& chmod +x share/genbuild.sh \
	&& chmod +x src/leveldb/build_detect_platform \
	&& ./autogen.sh && ./configure \
	&& make \
	&& make install

FROM chainmapper/walletbase-bionic as runtime

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/lib/libsodium* /usr/local/lib/
ENV LD_LIBRARY_PATH /lib=/usr/lib=/usr/local/lib
RUN mkdir /data
ENV HOME /data

#zmq port, rpc port & main port
EXPOSE 5555 6666 7233

COPY start.sh /start.sh
COPY gen_config.sh /gen_config.sh
COPY wallet.sh /wallet.sh
RUN chmod 777 /*.sh
CMD /start.sh genesis.conf GENX genesisd