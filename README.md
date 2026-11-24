# NetworkX Hello World

A small walking network of five CMU buildings. You build the graph, find the fastest route between two buildings, analyze the network and package the script as a container.

## My Completed Activity

I filled in the shortest route, walking time, degree counts and betweenness
centrality. I chose **Challenge 2: Wean Hall is closed for construction**.
The original route takes 5 minutes. With Wean Hall closed, the route is
Gates Hillman Center -> Tepper Building -> Cohon Center -> Hunt Library.
It takes 6 minutes, which is 1 minute longer. A copy of the graph is used so
the original network stays available for comparison.

The script also creates `cmu_network.png` and `cmu_network.graphml`.
Run `python -m pytest -v` to check the three original tests and the detour test.

The **Build and Publish Container** action tests the code and publishes a
Linux AMD64/ARM64 image on every push and on published releases.

### Run my release container

```bash
docker pull ghcr.io/luyaowang2002/networkx-hello-world:1.0.0
docker run --rm ghcr.io/luyaowang2002/networkx-hello-world:1.0.0
```

To also save the chart and GraphML on your computer, run from the project folder:

```bash
mkdir -p output
docker run --rm -v "$(pwd)/output:/output" -w /output ghcr.io/luyaowang2002/networkx-hello-world:1.0.0
```

Release: https://github.com/LuyaoWang2002/networkx-hello-world/releases/tag/v1.0.0

## Activity

1. Fork this repository.
2. On your fork's **Actions** tab, enable workflows. GitHub turns them off on forks.
3. Fill in the blanks marked `YOUR CODE HERE` and `TODO` in `cmu_campus_network.py`. The tests in `test_cmu_campus_network.py` run on every push and fail until Part 3 is filled in.
4. At the bottom of the script, pick one of the three challenges.
5. Add a GitHub Actions workflow that builds a container image on every push to `main` and pushes it to the GitHub Container Registry (GHCR). See [Build and Publish a Container](#build-and-publish-a-container).
6. When you're happy with the result, publish a release. The workflow builds a versioned image from it.
7. Submit the link to your release on Canvas. Grading uses your workflow runs and the release's container image.

## NetworkX Reference

### 1. Graph Creation
```python
G = nx.Graph()  # Undirected graph
G.add_nodes_from(buildings)  # Add nodes
G.add_edge(node1, node2, weight=time)  # Add weighted edges
```

### 2. Shortest Path Finding
```python
# Find the fastest route
path = nx.shortest_path(G, start, end, weight='weight')
distance = nx.shortest_path_length(G, start, end, weight='weight')
```

### 3. Network Analysis
```python
# Centrality: which building is most "central"?
betweenness = nx.betweenness_centrality(G, weight='weight')

# Degree: how many connections does each node have?
degree = G.degree(node)

# Average path length: average walking time between any two buildings
avg = nx.average_shortest_path_length(G, weight='weight')
```

### 4. Visualization
```python
pos = nx.spring_layout(G)  # Position nodes
nx.draw_networkx_nodes(G, pos)  # Draw nodes
nx.draw_networkx_edges(G, pos)  # Draw edges
nx.draw_networkx_labels(G, pos)  # Add labels
```

### Run the Complete Analysis
```bash
python cmu_campus_network.py
```

## Build and Publish a Container

### 1. Write a Dockerfile

Put a `Dockerfile` in the root of the repository. The one in `.devcontainer/` sets up a development environment and does not run the script. Yours does the following:

* Starts from `python:3.12-slim`.
* Installs `requirements.txt`.
* Copies `cmu_campus_network.py` into the image.
* Runs the script with `CMD`.

Build and run it locally before you write the workflow:

```bash
docker build -t networkx-hello-world .
docker run --rm networkx-hello-world
```

### 2. Write the Workflow

Add a second workflow in `.github/workflows/` that runs on pushes to `main` and when you publish a release:

```yaml
on:
  push:
    branches: [main]
  release:
    types: [published]
```

It checks out the code, signs in to `ghcr.io` with `docker/login-action` and builds and pushes the image with `docker/build-push-action`.

The workflow's `GITHUB_TOKEN` is read-only by default. Grant it permission to publish packages at the top of the workflow:

```yaml
permissions:
  contents: read
  packages: write
```

Image names must be lowercase, and GitHub usernames are often mixed case. `docker/metadata-action` builds a lowercase image name and tags for you. These tag rules name the image after the branch on a push and after the version on a release:

```yaml
tags: |
  type=ref,event=branch
  type=semver,pattern={{version}}
```

Pass its `tags` output to `docker/build-push-action`.

### 3. Publish a Release

On your repository's home page, choose **Releases**, then **Draft a new release**. Under **Choose a tag**, type a new tag in the form `v1.0.0` and create it, then choose **Publish release**. The workflow builds the image and tags it `1.0.0`. With a tag in any other form, the workflow has no tag for the image and the push fails.

To ship a change after that, publish a new release with a higher version, such as `v1.0.1`. Don't delete or reuse a published tag.

### 4. Make the Image Public

GHCR packages start out private. On your GitHub profile, open **Packages**, choose the image, then **Package settings**, and change its visibility to public so it can be pulled for grading.

### 5. Pull and Run It

Replace `your-username` with your GitHub username in lowercase and `1.0.0` with your release's version:

```bash
docker pull ghcr.io/your-username/networkx-hello-world:1.0.0
docker run --rm ghcr.io/your-username/networkx-hello-world:1.0.0
```

The `main` tag always holds the latest build from the `main` branch.

You can also pull and run the image from Docker Desktop.
