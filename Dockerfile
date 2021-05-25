FROM alpine:latest

ADD cdp-quota-customizer /cdp-quota-customizer
ENTRYPOINT ["./cdp-quota-customizer"]