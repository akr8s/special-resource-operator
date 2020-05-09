FROM registry.access.redhat.com/ubi8/go-toolset AS builder
WORKDIR /go/src/github.com/openshift-psap/special-resource-operator
COPY . .
RUN make build

FROM registry.access.redhat.com/ubi8/ubi
COPY --from=builder /go/src/github.com/openshift-psap/special-resource-operator/special-resource-operator /usr/bin/

RUN mkdir -p /etc/kubernetes/special-resource/nvidia-gpu
COPY assets/ /etc/kubernetes/special-resource/nvidia-gpu

RUN useradd special-resource-operator
USER special-resource-operator
ENTRYPOINT ["/usr/bin/special-resource-operator"]
LABEL io.k8s.display-name="OpenShift Special Resource Operator" \
      io.k8s.description="This is a component of OpenShift and manages special resources." \
      io.openshift.release.operator=true
