#!/usr/bin/env python3
"""Generate the Daypack teaching architecture PNG.

Output: ../images/architecture.png

Left-to-right story: build on EC2, ship to Docker Hub, run on Kubernetes,
call the KodeKloud LLM. Secrets Manager is dashed because today's lab still
bakes .env into the image.
"""
from pathlib import Path

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.security import SecretsManager
from diagrams.k8s.compute import Deployment, Pod
from diagrams.k8s.network import Service
from diagrams.onprem.client import User
from diagrams.onprem.container import Docker
from diagrams.onprem.network import Internet
from diagrams.programming.language import Python

HERE = Path(__file__).resolve().parent
OUT_DIR = HERE.parent / "images"
OUT_FILE = OUT_DIR / "architecture"

GRAPH = {
    "fontsize": "13",
    "bgcolor": "white",
    "pad": "0.6",
    "splines": "spline",
    "nodesep": "0.55",
    "ranksep": "0.7",
    "fontname": "Sans-Serif",
}
NODE = {"fontsize": "11", "fontname": "Sans-Serif"}
EDGE = {"fontsize": "10", "fontname": "Sans-Serif"}
CLUSTER = {"fontsize": "12", "fontname": "Sans-Serif"}
DESIRED = {
    "fontsize": "12",
    "fontname": "Sans-Serif",
    "style": "dashed",
    "pencolor": "#888888",
}


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    with Diagram(
        "Daypack: build on EC2, ship to Hub, run on Kubernetes",
        filename=str(OUT_FILE),
        outformat="png",
        show=False,
        direction="LR",
        graph_attr=GRAPH,
        node_attr=NODE,
        edge_attr=EDGE,
    ):
        with Cluster("Build  ·  EC2 (Amazon Linux)", graph_attr=CLUSTER):
            host = EC2("dev host")
            app = Python("Daypack\nStreamlit + LangChain")
            engine = Docker("docker build\n(+ COPY .env today)")
            host >> app >> engine

        with Cluster("Ship", graph_attr=CLUSTER):
            hub = Docker("Docker Hub\nai-k8-workshop:1.0")

        with Cluster("Run  ·  Kubernetes  ns/daypack", graph_attr=CLUSTER):
            deploy = Deployment("Deployment\nreplicas: 1")
            pod = Pod("Pod  :8501\nprobes /_stcore/health")
            svc = Service("ClusterIP  :8501")
            deploy >> pod
            svc >> pod

        with Cluster("Not in today's lab", graph_attr=DESIRED):
            secrets = SecretsManager("AWS Secrets Manager\nai-url, ai-key, model")

        llm = Internet("KodeKloud AI\n/v1  ·  deepseek-v4-flash")
        browser = User("Browser")

        engine >> Edge(label="push") >> hub
        hub >> Edge(label="pull Always") >> pod
        secrets >> Edge(
            label="desired at runtime",
            style="dashed",
            color="#888888",
            constraint="false",
        ) >> pod
        pod >> Edge(label="HTTPS") >> llm
        browser >> Edge(label="port-forward 8501\n(classroom, no Ingress)") >> svc

    print(f"Wrote {OUT_FILE}.png")


if __name__ == "__main__":
    main()
