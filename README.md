# Hello-Go: A Simple Go Web Application

This repository contains a basic Go web application designed for demonstration and learning purposes.  It serves a simple "Hello, World!" message on a specified port. This README provides instructions on how to install, run, and deploy the application to a Kubernetes cluster using the provided YAML file.

## Features

*   Simple "Hello, World!" web server.
*   Dockerfile for easy containerization.
*   Kubernetes deployment and service configurations.

## Prerequisites

Before you begin, ensure you have the following installed:

*   **Go:**  [https://go.dev/dl/](https://go.dev/dl/)
*   **Git:** [https://git-scm.com/downloads](https://git-scm.com/downloads)
*   **Docker:** [https://www.docker.com/get-started](https://www.docker.com/get-started)
*   **kubectl:** [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/)
*   **Minikube:** [https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)
*   
## Installation and Running Locally

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/kaldyka/hello-go.git
    cd hello-go
    ```

2.  **Build the Go application:**

    ```bash
    go build -o hello-go hello.go
    ```

3.  **Run the application (with default port 8080):**

    ```bash
    ./hello-go
    ```

4.  **Access the application:**

    Open your web browser and navigate to `http://localhost:80` You should see "Hello, World!".

## Containerization (Docker)

1.  **Build the Docker image:**

    ```bash
    docker build -t hello-go .
    ```

2.  **Run the Docker container:**

    ```bash
    docker run -p 80:80 hello-go:latest
    ```
    
3.  **Access the application:**

    Open your web browser and navigate to `http://localhost:80`  You should see "Hello, World!".

## Kubernetes Deployment on Minikube

This section outlines how to deploy the application to a Minikube cluster using the provided YAML file (assuming it's named `deployment.yaml`).

**Steps for Cluster Provisioning with Minikube**

  ```bash
  minikube start
  ```

This command will download and start the Minikube VM, configure `kubectl` to point to it, and set up the Kubernetes cluster.  You may need to specify a driver (e.g., `minikube start --driver=docker`) depending on your system.  Check the Minikube documentation for details.
    
**Steps for Cluster Provisioning (Deployment via YAML)**

1.  **Apply the YAML file to your Kubernetes cluster:**

    ```bash
    kubectl apply -f hello-deployment.yaml
    ```

3.  **Verify the deployment:**

    ```bash
    kubectl get deployments
    kubectl get pods
    kubectl get services
    ```

    *   `kubectl get deployments` shows the status of the deployment.  Ensure the `DESIRED` and `CURRENT` values match and that the deployment is available.
    *   `kubectl get pods` lists the pods running the application.  Check the `STATUS` to ensure they are running correctly (e.g., `Running`).  You can also check the logs of a pod using `kubectl logs <pod-name>` for any errors.
    *   `kubectl get services` shows the service configuration.  If you used `LoadBalancer`, it will show an `EXTERNAL-IP` once it's provisioned (this may take a few minutes).  If you used `NodePort`, you can access the application using the node's IP address and the assigned node port (check the `PORT(S)` column).  If you used `ClusterIP`, it is only accessible internally within the cluster.

4.  **Access the application:**

    *   **LoadBalancer:**  Use the `EXTERNAL-IP` provided by `kubectl get services`. Navigate to `http://<EXTERNAL-IP>` (or `https://<EXTERNAL-IP>` if you've configured SSL).
    *   **NodePort:** Use the IP address of any node in your cluster and the node port. Navigate to `http://<node-ip>:<node-port>`.  You can find the node's IP address using `kubectl get nodes -o wide`.
    *   **ClusterIP:**  To access a ClusterIP service, you typically need to use port forwarding or access it from within another pod in the cluster.  Use  `kubectl port-forward service/hello-go-service 8080:80` and then navigate to `http://localhost:8080` in your local browser.  **Note:** This is generally only for testing/debugging and not for production access.

## Cleanup

To remove the deployment and service:

```bash
kubectl delete -f hello-deployment.yaml
```