# Hello-Go: A Simple Go Web Application

This repository contains a basic Go web application designed for demonstration and learning purposes. It serves a simple "Hello, World!" message on a specified port. This README provides instructions on how to install, run, and deploy the application to a Kubernetes cluster using the provided YAML file and **Terraform**. The Terraform files are designed for deployment on a Minikube cluster within the `hello` namespace.

## Features

*   Simple "Hello, World!" web server.
*   Dockerfile for easy containerization.
*   Kubernetes deployment and service configurations.
*   Specific instructions for Minikube.
*   **Terraform configuration for automated deployment to Minikube (hello namespace).**

## Prerequisites

Before you begin, ensure you have the following installed:

*   **Go:**  [https://go.dev/dl/](https://go.dev/dl/)
*   **Git:** [https://git-scm.com/downloads](https://git-scm.com/downloads)
*   **Docker:** [https://www.docker.com/get-started](https://www.docker.com/get-started)
*   **kubectl:** [https://kubernetes.io/docs/tasks/tools/](https://kubernetes.io/docs/tasks/tools/)
*   **Minikube:** [https://minikube.sigs.k8s.io/docs/start/](https://minikube.sigs.k8s.io/docs/start/)
*   **Terraform:** [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
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

This section outlines how to deploy the application to a Minikube cluster using the provided YAML file (assuming it's named `hello-deployment.yaml`).

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

5.  **Cleanup:**

To remove the deployment and service:

```bash
kubectl delete -f hello-deployment.yaml
```

## Deploy with Terraform

This section outlines how to deploy the application to a Minikube cluster using Terraform.
    
**Steps for Cluster Provisioning (Deployment via Terraform)**

1.  **Initialize Terraform:**

    ```bash
    terraform init
    ```

    This command downloads the necessary Terraform providers and initializes the working directory.

2.  **Plan the deployment:**

    ```bash
    terraform plan
    ```

    This command creates an execution plan, showing you what Terraform will do to create the resources.  Review the plan carefully to ensure it aligns with your expectations.  If you've defined variables, you can pass them here using `-var` flags, e.g., `terraform plan -var="docker_image=your-dockerhub-username/hello-go:latest"`. You can also place your settings in a `terraform.tfvars` file (see example above) and Terraform will load them automatically.

3.  **Apply the Terraform configuration:**

    ```bash
    terraform apply
    ```

    This command applies the changes defined in the plan and creates the resources in your Minikube cluster.  You will be prompted to confirm the changes. Type `yes` to proceed.  You can also use `terraform apply -auto-approve` to skip the confirmation prompt (not recommended for production).

4.  **Verify the deployment:**

    ```bash
    kubectl get deployments -n hello
    kubectl get pods -n hello
    kubectl get services -n hello
    ```

    *   `kubectl get deployments -n hello` shows the status of the deployment in the `hello` namespace.  Ensure the `DESIRED` and `CURRENT` values match and that the deployment is available.
    *   `kubectl get pods -n hello` lists the pods running the application in the `hello` namespace.  Check the `STATUS` to ensure they are running correctly (e.g., `Running`).  You can also check the logs of a pod using `kubectl logs -n hello <pod-name>` for any errors.
    *   `kubectl get services -n hello` shows the service configuration in the `hello` namespace.

5.  **Access the application in Minikube:**

    Since we are using `NodePort` (or potentially `LoadBalancer` with `minikube tunnel`), get the Minikube IP address and the assigned node port:

    ```bash
    minikube ip
    kubectl get service hello-go-service -n hello
    ```

    The `kubectl get service` command will output something like:

    ```
    NAME               TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
    hello-go-service   NodePort   10.100.10.100   <none>        80:30080/TCP   10s
    ```

    In this example, the node port is `30080`.  Use the Minikube IP address and this node port to access the application:

    Navigate to `http://<minikube-ip>:30080` in your web browser.  You should see "Hello, World!".

    **Alternatively, if you are using `LoadBalancer` you must run:**

    ```bash
    minikube tunnel
    ```
    in a separate terminal to expose the service. After that the `EXTERNAL-IP` column will be populated.  Use that external IP address in the browser.

6.  **Destroy the infrastructure**

    To remove the deployment and service created by Terraform:
    
    ```bash
    terraform destroy
    ```
    
    This command will destroy all resources managed by the Terraform configuration. You will be prompted to confirm the changes. Type yes to proceed. You can also use terraform destroy -auto-approve (not recommended for production).
    
    To stop Minikube:
    
    ```bash
    minikube stop
```

